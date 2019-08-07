//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import AudioToolbox

class MyAccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let reuseIdentifier = "AccountCell"

    let account: EthAccount = EthAccount.accountInstance
    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3
    let util = Util()

    var accounts: [CustomAddress] = [CustomAddress]()
    var accountSelected: Address!
    var symbol: String!

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "내 계정")
        self.transparentNavigationBar()
        self.setRightNavButton()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(tableView)

        setupLayout()
        self.showSpinner()
    }

    override func viewDidAppear(_ animated: Bool) {
        getAccount()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setRightNavButton(){
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.setTitleColor(UIColor(key: "dark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightButton
    }

    private func getAccount(){
        accounts = account.getAddressArray()!
        accountSelected = account.getAddress()
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

        cell.checkImage.isHidden = true
        cell.accountLabel.textColor = UIColor(key: "darker")
        cell.privateKeyLabel.isHidden = true
        if(accounts[indexPath.section].address == accountSelected.description){
            cell.accountLabel.textColor = UIColor(key: "dark")
            cell.checkImage.isHidden = false
        }
        if(accounts[indexPath.section].isPrivateKey){
            cell.privateKeyLabel.isHidden = false
        }

        cell.accountLabel.text = accounts[indexPath.section].name
        cell.addressLabel.text = accounts[indexPath.section].address

        web3.getBalance(address: accounts[indexPath.section].address, completion: {(balance) in
            DispatchQueue.main.async {
                let balanceTrimmed = self.util.trimBalance(balance: balance)
                cell.balanceLabel.text = balanceTrimmed + " " + self.symbol
            }
        })

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
            account.deleteAccount(account: accounts[indexPath.section])
            getAccount()
            self.tableView.deleteSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
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
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.hideSpinner()
    }

    private func selectAccount(index: Int){
        account.setAddress(index: index)
    }

    @objc private func backPressed(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    @objc private func addPressed(_ sender: UIButton){
        let addAccountVC = AddAccountVC()
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }
}
