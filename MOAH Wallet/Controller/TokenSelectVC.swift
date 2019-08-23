//
// Created by 김경인 on 2019-07-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class TokenSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TokenObserver {

    private let reuseIdentifier = "TokenSelectCell"

    let screenSize = UIScreen.main.bounds
    let ethToken = EthToken.shared
    let web3 = CustomWeb3.shared

    var alertTitle: String?
    var alertBody: String?
    var alertButtonTitle: String?
    var delegate: MainControllerDelegate?
    var tokenArray: [TokenInfo]!
    var token: CustomToken?
    var isInit = false
    var id: String = "TokenSelectVC"

    let alertView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.isOpaque = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.text = "암호화폐 선택"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.setTitleColor(UIColor(key: "dark"), for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    init(){
        self.token = ethToken.token
        super.init(nibName: nil, bundle: nil)
        ethToken.attachTokenObserver(self)
        isInit = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TokenCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(!isInit){
            self.token = ethToken.token
            ethToken.attachTokenObserver(self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        ethToken.detachTokenObserver(self)
    }

    private func setupLayout(){
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true

        addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true

        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TokenCell
        if(indexPath.row == 0){
            cell.setAsEther()
            if(token == nil){ cell.addCheckImage()}
            return cell
        }
        let name = tokenArray[indexPath.row-1].value(forKey: "name") as! String
        let symbol = tokenArray[indexPath.row-1].value(forKey: "symbol") as! String
        let address = tokenArray[indexPath.row-1].value(forKey: "address") as! String
        let logo = tokenArray[indexPath.row-1].value(forKey: "logo") as! Data

        let nameLabel = symbol + " - " + name
        cell.setTokenValue(name: nameLabel, address: address, logo: logo)

        if(self.token != nil && address == self.token!.address){
            cell.addCheckImage()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenArray.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1519)
        if(indexPath.row == 0){
            ethToken.setToken(index: nil)
        }
        else{
            ethToken.setToken(index: indexPath.row-1)
        }
        tableView.reloadData()
        self.delegate?.tokenEnded(selected: true)
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
        if(indexPath.row < 1){ return false}
        else { return true}
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            AudioServicesPlaySystemSound(1519)
            delegate?.willReload()

            let networkPredicate = NSPredicate(format: "network = %@", web3.network!.name)
            let address = tokenArray[indexPath.row-1].value(forKey: "address") as! String
            ethToken.deleteToken(address: address)
            self.tokenArray = ethToken.fetchToken(networkPredicate)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }

    func tokenChanged(token: CustomToken?) {
        self.token = token
    }


    @objc func addPressed(_ sender: UIButton){
        self.delegate?.tokenEnded(selected: false)
    }

}
