//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import AudioToolbox
import BigInt

class MyAccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, AddressObserver {

    private let reuseIdentifier = "AccountCell"

    let account: EthAccount = EthAccount.shared
    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.shared
    let ethAddress = EthAddress.address
    let util = Util()

    var accounts: [MOAHAddress] = [MOAHAddress]()
    var symbol: String!
    var balance: [String] = [String]()
    var refreshControl = UIRefreshControl()
    var address: CustomAddress!
    var id: String = "MyAccountVC"
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
        button.setTitle("계정 추가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    init(){
        self.address = ethAddress.address!
        super.init(nibName: nil, bundle: nil)
        ethAddress.attachAddressObserver(self)
        isInit = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "내 계정")
        self.transparentNavigationBar()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")

    }

    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(!isInit){
            self.address = ethAddress.address!
            ethAddress.attachAddressObserver(self)
        }
        getAccount()
        getBalance(completion: {
            DispatchQueue.main.async{
                self.view.addSubview(self.tableView)
                self.view.addSubview(self.addButton)

                self.setupLayout()

                self.refreshControl.tintColor = UIColor(key: "grey")
                self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
                self.tableView.addSubview(self.refreshControl)

                self.tableView.reloadData()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        ethAddress.detachAddressObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    private func getAccount(){
        accounts = ethAddress.fetchAddress(nil)
    }

    private func getBalance(completion: @escaping () -> ()){
        self.balance = []

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.global(qos: .userInteractive).sync{
            for index in 0..<self.accounts.count{
                let indexPath = IndexPath(row: 0, section: index)
                //var balance = BigUInt(0)
                let address = accounts[indexPath.section].value(forKey: "address") as! String
                web3.getBalanceSync(address: address, completion: {(balance) in
                    let balanceTrimmed = self.util.trimBalance(balance: balance)
                    let text = balanceTrimmed + " " + self.symbol
                    self.balance.append(text)
                })
            }
            group.leave()
        }

        group.notify(queue: .global(qos: .userInteractive)){
            completion()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AccountCell
        let currentAddress = accounts[indexPath.section].value(forKey: "address") as! String
        let currentName = accounts[indexPath.section].value(forKey: "name") as! String
        let currentIsPrivateKey = accounts[indexPath.section].value(forKey: "isPrivateKey") as! Bool

        cell.addSymbol(symbol: self.symbol)
        cell.checkImage.isHidden = true
        cell.accountLabel.textColor = UIColor(key: "darker")
        cell.privateKeyLabel.isHidden = true

        if(currentAddress == address.address){
            cell.accountLabel.textColor = UIColor(key: "dark")
            cell.checkImage.isHidden = false
        }
        if(currentIsPrivateKey){
            cell.privateKeyLabel.isHidden = false
        }

        cell.accountLabel.text = currentName
        cell.addressLabel.text = currentAddress
        cell.balanceLabel.text = self.balance[indexPath.section]

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "숨기기") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(key: "dark")
        return [deleteButton]
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section < 1){ return false}
        else { return true}
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let address = self.accounts[indexPath.section].value(forKey: "address") as! String
            let name = self.accounts[indexPath.section].value(forKey: "name") as! String
            let isPrivateKey = self.accounts[indexPath.section].value(forKey: "isPrivateKey") as! Bool
            let path = self.accounts[indexPath.section].value(forKey: "path") as! String
            let account = CustomAddress(address: address, name: name, isPrivateKey: isPrivateKey, path: path)

            self.account.deleteAccount(account: account)
            getAccount()
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
            self.balance.remove(at: indexPath.section)
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenSize.height/75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1519)
        selectAccount(index: indexPath.section)
        getAccount()
        self.tableView.reloadData()
        self.reloadMainContainerVC()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.hideSpinner()
        self.hideTransparentView()
    }

    private func selectAccount(index: Int){
        ethAddress.setAddress(index: index)
    }

    func addressChanged(address: CustomAddress) {
        self.address = address
    }

    @objc private func addPressed(_ sender: UIButton){
        let addAccountVC = AddAccountVC()
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }

    @objc private func refresh(_ sender: UIRefreshControl) {
        self.showTransparentView()
        getAccount()
        DispatchQueue.global(qos: .userInitiated).async{
            self.getBalance(completion: {
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
}
