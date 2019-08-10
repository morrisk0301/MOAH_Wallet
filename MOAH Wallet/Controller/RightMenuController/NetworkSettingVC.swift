//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class NetworkSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let reuseIdentifier = "networkCell"

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3

    var networks: [CustomWeb3Network] = [CustomWeb3Network]()
    var network: String!

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("네트워크 추가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "네트워크 설정")
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
        getNetwork()
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func getNetwork(){
        network = web3.getNetwork()
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
            cell.networkLabel.text = "Etheruem 메인넷"
            break
        case "robsten":
            cell.networkLabel.text = "Robsten 테스트넷"
            break
        case "kovan":
            cell.networkLabel.text = "Kovan 테스트넷"
            break
        case "rinkeby":
            cell.networkLabel.text = "Rinkeby 테스트넷"
            break
        default:
            cell.networkLabel.text = networks[indexPath.section].name
        }

        if(networks[indexPath.section].name == network){
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
        AudioServicesPlaySystemSound(1519)

        if(indexPath.section < 4){
            self.web3.setNetwork(network: self.networks[indexPath.section].name)
            self.getNetwork()
            self.tableView.reloadData()
        }
        else{
            self.showSpinner()
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try self.web3.setNetwork(name: self.networks[indexPath.section].name, url: self.networks[indexPath.section].url, new: false)
                } catch {
                    let util = Util()
                    DispatchQueue.main.async {
                        let alertVC = util.alert(title: "네트워크 오류", body: "네트워크에 연결할 수 없습니다.", buttonTitle: "확인", buttonNum: 1, completion: { _ in
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
        let deleteButton = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(key: "dark")
        return [deleteButton]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section < 4){ return false}
        else { return true}
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            web3.delNetwork(name: networks[indexPath.section].name, url: networks[indexPath.section].url)
            getNetwork()
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            tableView.reloadData()
        }
    }

    @objc func addPressed(_ sender: UIButton){
        let controller = AddNetworkVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
