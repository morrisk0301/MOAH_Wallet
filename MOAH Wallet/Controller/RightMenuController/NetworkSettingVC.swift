//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class NetworkSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, NetworkObserver {

    private let reuseIdentifier = "networkCell"

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.shared

    var networks: [CustomWeb3Network] = [CustomWeb3Network]()
    var network: CustomWeb3Network
    var id: String = "NetworkSettingVC"
    var isInit = true

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Add Network".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    init(){
        self.network = web3.network!
        super.init(nibName: nil, bundle: nil)
        web3.attachNetworkObserver(self)
        isInit = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "Network Settings".localized)
        self.transparentNavigationBar()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NetworkCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(tableView)
        view.addSubview(addButton)

        getNetwork()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(!isInit){
            self.network = web3.network!
            web3.attachNetworkObserver(self)
        }
        getNetwork()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        web3.detachNetworkObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func getNetwork(){
        networks = web3.getNetworks()
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true

        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenSize.height/75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NetworkCell

        cell.checkImage.isHidden = true
        cell.networkLabel.textColor = UIColor(key: "darker")
        cell.urlLabel.text = networks[indexPath.section].url.description

        switch(networks[indexPath.section].name){
        case "mainnet":
            cell.networkLabel.text = "Ethereum Mainnet".localized
            break
        case "ropsten":
            cell.networkLabel.text = "Ropsten Testnet".localized;
            break
        case "rinkeby":
            cell.networkLabel.text = "Rinkeby Testnet".localized;
            break
        default:
            cell.networkLabel.text = networks[indexPath.section].name
        }

        if(networks[indexPath.section] == network){
            cell.networkLabel.textColor = UIColor(key: "dark")
            cell.checkImage.isHidden = false
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return networks.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/8
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.reloadMainContainerVC()
        AudioServicesPlaySystemSound(1519)

        if(indexPath.section < 3){
            self.web3.setNetwork(network: self.networks[indexPath.section])
            self.getNetwork()
            self.tableView.reloadData()
        }
        else{
            self.showSpinner()
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try self.web3.setNetwork(network: self.networks[indexPath.section], new: false)
                } catch {
                    let util = Util()
                    DispatchQueue.main.async {
                        let alertVC = util.alert(title: "Error".localized, body: "Unable to connect to network".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: { _ in
                            self.hideSpinner()
                        })
                        self.present(alertVC, animated: false)
                    }
                }
                self.getNetwork()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.hideSpinner()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete".localized) { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(key: "dark")
        return [deleteButton]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section < 3){ return false}
        else { return true}
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            AudioServicesPlaySystemSound(1519)
            web3.delNetwork(network: networks[indexPath.section])
            getNetwork()
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            tableView.reloadData()
        }
    }

    func networkChanged(network: CustomWeb3Network) {
        self.network = network
    }

    @objc func addPressed(_ sender: UIButton){
        let controller = AddNetworkVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
