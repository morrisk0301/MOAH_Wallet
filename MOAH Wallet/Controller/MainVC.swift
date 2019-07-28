//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

class MainVC: UIViewController{

    var signUp = false
    var isExpand = false
    var tempMnemonic: String?
    var delegate: MainControllerDelegate?

    let screenSize = UIScreen.main.bounds
    let web3: Web3Custom = Web3Custom.web3
    let util = Util()

    let tokenView: MainTokenView = {
        let tokenView = MainTokenView()
        tokenView.translatesAutoresizingMaskIntoConstraints = false

        return tokenView
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.text = "0.00000 ETH"
        label.font = UIFont(name:"NanumSquareRoundB", size: 40, dynamic: true)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let depositButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("입금", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let transferButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let txView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(key: "dark")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
        view.addSubview(depositButton)
        view.addSubview(transferButton)
        //view.addSubview(txView)
        tokenView.setTokenString(tokenString: "Ethereum")


        /*
        let account: EthAccount = EthAccount.accountInstance
        let KS = account.getKeyStore()
        let web3Kovan = Web3(infura: .kovan)
        let keyStoreManager = KeystoreManager([KS])
        web3Kovan.keystoreManager = keyStoreManager

        let amount = BigUInt(10000000000000000)
        let toAddress = Address("0xAa7725FF2Bd0B88e5EA57f0Ea74D2Bf1cA61ddaf")
        var options = Web3Options.default
        options.from = KS.addresses.first!

        let intermediateTX =  try! web3Kovan.eth.sendETH(to: toAddress, amount: amount, options: options)
        try! intermediateTX.send(password: "123")
        */



        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(signUp){
            let mnemonicWarningVC = MnemonicWarningVC()
            mnemonicWarningVC.tempMnemonic = self.tempMnemonic!

            self.navigationController?.pushViewController(mnemonicWarningVC, animated: false)

            return
        }

        web3.getBalance(address: nil, completion: {(balance) in
            DispatchQueue.main.async {
                let balanceTrimmed = self.util.trimBalance(balance: balance)
                self.balanceLabel.text = balanceTrimmed
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupBarButton(){
        let leftUIButton: UIButton = UIButton(type: .custom)
        leftUIButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        leftUIButton.setImage(UIImage(named: "menuIcon"), for: .normal)
        leftUIButton.addTarget(self, action: #selector(leftMenuClicked(_:)), for: .touchUpInside)

        let leftButton = UIBarButtonItem(customView: leftUIButton)
        leftButton.customView?.widthAnchor.constraint(equalToConstant: (view.frame.width/30)*1.5).isActive = true
        leftButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/30).isActive = true

        let rightUIButton: UIButton = UIButton(type: .custom)
        rightUIButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        rightUIButton.setImage(UIImage(named: "menuIcon2"), for: .normal)
        rightUIButton.addTarget(self, action: #selector(rightMenuClicked(_:)), for: .touchUpInside)

        let rightButton = UIBarButtonItem(customView: rightUIButton)
        rightButton.customView?.widthAnchor.constraint(equalToConstant: view.frame.width/12).isActive = true
        rightButton.customView?.heightAnchor.constraint(equalToConstant: view.frame.width/12).isActive = true

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

        balanceLabel.topAnchor.constraint(equalTo: tokenView.bottomAnchor, constant: screenHeight/15).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        balanceLabel.centerXAnchor.constraint(equalTo: tokenView.centerXAnchor).isActive = true
        balanceLabel.widthAnchor.constraint(equalToConstant: screenWidth/1.5).isActive = true

        depositButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: screenHeight/15).isActive = true
        depositButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/7).isActive = true
        depositButton.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        depositButton.widthAnchor.constraint(equalToConstant: screenWidth/3).isActive = true

        transferButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: screenHeight/15).isActive = true
        transferButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/7).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: screenWidth/3).isActive = true

        //txView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //txView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //txView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //txView.heightAnchor.constraint(equalToConstant: screenHeight/2).isActive = true
    }

    @objc func leftMenuClicked(_ sender: UIBarButtonItem){
        delegate?.leftSideMenuClicked(forMenuOption: nil)
    }

    @objc func rightMenuClicked(_ sender: UIBarButtonItem){
        delegate?.rightSideMenuClicked(forMenuOption: nil)
    }
}
