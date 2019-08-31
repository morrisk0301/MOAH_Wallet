//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CheckVerifiedDelegate{

    private let reuseIdentifier = "TXHistoryCell"

    var signUp = false
    var isExpand = false
    var tempMnemonic: String?
    var delegate: MainControllerDelegate?
    var balance: BigUInt?
    var ethBalance: BigUInt?
    var balanceString: String?
    var decimals = 18
    var symbol = "ETH"
    var txHistory: [TXInfo] = [TXInfo]()
    var refreshControl = UIRefreshControl()

    let screenSize = UIScreen.main.bounds
    let util = Util()

    let mainTopView: MainTopView = {
        let view = MainTopView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let txLabel: UILabel = {
        let label = UILabel()

        label.text = "Transaction History".localized
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.backgroundColor = .white
        label.textAlignment = .center

        return label
    }()

    let txView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.transparentNavigationBar()
        navigationItem.title = "MOAH Wallet"

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 25, dynamic: true)!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white]

        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(screenSize.height/300, for: .default)

        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)


        setupBarButton()

        view.addSubview(mainTopView)
        view.addSubview(txView)
        mainTopView.balanceLabel.text = "0.0000 " + symbol
        mainTopView.tokenView.setTokenString(tokenString: "Ethereum")
        mainTopView.delegate = self

        txView.delegate = self
        txView.dataSource = self
        txView.showsVerticalScrollIndicator = false
        txView.register(TXCell.self, forCellReuseIdentifier: reuseIdentifier)
        txView.addSubview(refreshControl)

        if(signUp){
            delegate?.isSignUp()
        }
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupBarButton(){
        let leftUIButton: UIButton = UIButton(type: .custom)
        leftUIButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let leftBtnImage = UIImageView(image: UIImage(named: "menuIcon"))
        leftBtnImage.translatesAutoresizingMaskIntoConstraints = false
        leftUIButton.addSubview(leftBtnImage)
        leftBtnImage.centerYAnchor.constraint(equalTo: leftUIButton.centerYAnchor).isActive = true
        leftBtnImage.centerXAnchor.constraint(equalTo: leftUIButton.centerXAnchor).isActive = true
        leftBtnImage.widthAnchor.constraint(equalToConstant: (view.frame.width/20)*1.2).isActive = true
        leftBtnImage.heightAnchor.constraint(equalToConstant:(view.frame.height/60)*1.2).isActive = true
        leftUIButton.addTarget(self, action: #selector(leftMenuClicked(_:)), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: leftUIButton)
        if UIDevice.current.userInterfaceIdiom == .pad {
            leftButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/20).isActive = true
            leftButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/20).isActive = true
        }else{
            leftButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
            leftButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        }

        let rightUIButton: UIButton = UIButton(type: .custom)
        rightUIButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightBtnImage = UIImageView(image: UIImage(named: "menuIcon2"))
        rightBtnImage.translatesAutoresizingMaskIntoConstraints = false
        rightUIButton.addSubview(rightBtnImage)
        rightBtnImage.centerYAnchor.constraint(equalTo: rightUIButton.centerYAnchor).isActive = true
        rightBtnImage.centerXAnchor.constraint(equalTo: rightUIButton.centerXAnchor).isActive = true
        rightBtnImage.widthAnchor.constraint(equalToConstant: view.frame.width/12*1.2).isActive = true
        rightBtnImage.heightAnchor.constraint(equalToConstant: view.frame.height/25*1.2).isActive = true
        rightUIButton.addTarget(self, action: #selector(rightMenuClicked(_:)), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: rightUIButton)
        if UIDevice.current.userInterfaceIdiom == .pad {
            rightButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/20).isActive = true
            rightButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/20).isActive = true
        }else{
            rightButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
            rightButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        }

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }

    private func setupLayout(){
        txView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        txView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        txView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        txView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TXCell
        if(indexPath.section == 0){
            cell.addSubview(mainTopView)
            cell.backgroundColor = .clear
            cell.statusLabel.isHidden = true

            mainTopView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            mainTopView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            mainTopView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            mainTopView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true

            return cell
        }

        if(indexPath.row > self.txHistory.count-1){
            if(indexPath.row == 0){
                cell.nonTX()
                return cell
            }
            else{
                cell.nonData()
                return cell
            }
        }


        cell.nonBlankConstraint.isActive = true

        let category = self.txHistory[indexPath.row].value(forKey: "category") as! String
        let status = self.txHistory[indexPath.row].value(forKey: "status") as! String
        let date = self.txHistory[indexPath.row].value(forKey: "date") as! Date
        cell.setTXValue(category: category, date: date)
        cell.setStatusLabel(status: status)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if(section != 1){return 0}

        return (screenSize.height)*0.05
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.applyShadow()
        view.layer.cornerRadius = 0
        view.addSubview(txLabel)
        txLabel.centerInSuperview()

        if(section != 1){return nil}

        return view
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        if(self.txHistory.count < 5){
            return 5
        }
        return self.txHistory.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return (screenSize.height)*0.34
        }
        return (screenSize.height)*0.10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            return
        }
        if(self.txHistory.count == 0){
            return
        }
        if(indexPath.row > self.txHistory.count){
            return
        }
        let controller = TXDetailVC()
        controller.txInfo = self.txHistory[indexPath.row]
        self.present(UINavigationController(rootViewController: controller), animated: true)
    }

    func checkClicked() {
        let account: EthAccount = EthAccount.shared
        if(account.getIsVerified()){
            let controller = TransferVC()
            controller.decimals = self.decimals
            controller.balance = self.balance!
            controller.balanceString = self.balanceString!
            controller.symbol = self.symbol
            controller.ethBalance = self.ethBalance
            self.present(UINavigationController(rootViewController: controller), animated: true)
        }
        else{
            let alertVC = util.alert(title: "Unverified Wallet".localized, body: "Please continue after getting your wallet verified.".localized, buttonTitle: "Verify".localized, buttonNum: 2, completion: {(complete) in
                if(complete){
                    DispatchQueue.main.async{
                        let controller = MnemonicSettingVC()
                        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
                    }
                }
            })
            self.present(alertVC, animated: false)
        }
    }

    @objc func leftMenuClicked(_ sender: UIBarButtonItem){
        delegate?.leftSideMenuClicked(forMenuOption: nil)
    }

    @objc func rightMenuClicked(_ sender: UIBarButtonItem){
        delegate?.rightSideMenuClicked(forMenuOption: nil)
    }

    @objc private func refresh(_ sender: UIRefreshControl) {
        delegate?.reload()
    }
}
