//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private let reuseIdentifier = "TXHistoryCell"

    var signUp = false
    var isExpand = false
    var tempMnemonic: String?
    var delegate: MainControllerDelegate?
    var balance: BigUInt?
    var balanceString: String?
    var symbol = "ETH"

    let screenSize = UIScreen.main.bounds
    let util = Util()

    let tokenView: MainTokenView = {
        let tokenView = MainTokenView()
        tokenView.translatesAutoresizingMaskIntoConstraints = false

        return tokenView
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 40, dynamic: true)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let transferButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transferPressed(_:)), for: .touchUpInside)

        return button
    }()

    let txLabel: UILabel = {
        let label = UILabel()

        label.text = "거래내역"
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let txView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
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

        setupBarButton()

        view.addSubview(tokenView)
        view.addSubview(balanceLabel)
        view.addSubview(transferButton)
        view.addSubview(txLabel)
        view.addSubview(txView)
        balanceLabel.text = "0.00000 " + symbol
        tokenView.setTokenString(tokenString: "Ethereum")

        txLabel.applyShadow()

        txView.delegate = self
        txView.dataSource = self
        txView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        if(signUp){
            delegate?.isSignUp()
        }
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupBarButton(){
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
        leftButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        leftButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true

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
        rightButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true
        rightButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/10).isActive = true

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }

    private func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        tokenView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight/20).isActive = true
        tokenView.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        tokenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/5).isActive = true
        tokenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/5).isActive = true

        balanceLabel.topAnchor.constraint(equalTo: tokenView.bottomAnchor).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenHeight/6).isActive = true
        balanceLabel.centerXAnchor.constraint(equalTo: tokenView.centerXAnchor).isActive = true
        balanceLabel.widthAnchor.constraint(equalToConstant: screenWidth*0.9).isActive = true

        transferButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor).isActive = true
        transferButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: screenWidth/2.5).isActive = true

        txLabel.topAnchor.constraint(equalTo: transferButton.bottomAnchor, constant: screenHeight/20).isActive = true
        txLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        txLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        txLabel.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true

        txView.topAnchor.constraint(equalTo: txLabel.bottomAnchor).isActive = true
        txView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        txView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        txView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell

        cell.menuLabel.text = "거래내역 테스트"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    @objc func leftMenuClicked(_ sender: UIBarButtonItem){
        delegate?.leftSideMenuClicked(forMenuOption: nil)
    }

    @objc func rightMenuClicked(_ sender: UIBarButtonItem){
        delegate?.rightSideMenuClicked(forMenuOption: nil)
    }

    @objc func transferPressed(_ sender: UIButton){
        let account: EthAccount = EthAccount.accountInstance
        if(account.getIsVerified()){
            let controller = TransferVC()
            controller.balance = self.balance!
            controller.balanceString = self.balanceString!
            controller.symbol = self.symbol
            self.present(UINavigationController(rootViewController: controller), animated: true)
        }
        else{
            let alertVC = util.alert(title: "미인증 계정", body: "비밀 시드 구문 미인증 계정입니다.\n인증 후 이용해주시기 바랍니다.", buttonTitle: "인증하기", buttonNum: 2, completion: {(complete) in
                if(complete){
                    DispatchQueue.main.async{
                        let transition = LeftTransition()
                        let controller = MnemonicSettingVC()
                        self.view.window!.layer.add(transition, forKey: kCATransition)
                        self.present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
                    }
                }
            })
            self.present(alertVC, animated: false)
        }

    }
}
