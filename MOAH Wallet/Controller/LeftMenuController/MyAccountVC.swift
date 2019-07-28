//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift

class MyAccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let reuseIdentifer = "AccountCell"

    let account: EthAccount = EthAccount.accountInstance
    let screenSize = UIScreen.main.bounds
    let web3: Web3Custom = Web3Custom.web3
    let util = Util()

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
        tableView.register(AccountCell.self, forCellReuseIdentifier: reuseIdentifer)

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(tableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
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

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let accounts = account.getAddressArray() else { return 0 }
        return accounts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! AccountCell

        guard let accounts = account.getAddressArray() else { return cell }
        guard let accountSelected = account.getAddress() else { return cell}
        let addressName = account.getAddressNameArray()

        cell.checkImage.isHidden = true
        if(accounts[indexPath.section].description == accountSelected.description){
            cell.checkImage.isHidden = false
        }

        if(indexPath.section == 0){
            cell.accountLabel.text = "주 계정"
            cell.accountLabel.textColor = UIColor(key: "dark")
        }
        else{
            cell.accountLabel.text = addressName[indexPath.section-1]
        }
        cell.addressLabel.text = accounts[indexPath.section].description

        web3.getBalance(address: accounts[indexPath.section].description, completion: {(balance) in
            DispatchQueue.main.async {
                let balanceTrimmed = self.util.trimBalance(balance: balance)
                cell.balanceLabel.text = balanceTrimmed
            }
        })

        return cell
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
        selectAccount(index: indexPath.section)
        self.tableView.reloadData()
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
