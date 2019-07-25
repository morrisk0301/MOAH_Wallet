//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

class MainVC: UIViewController, TokenViewDelegate{

    var signUp = false
    var isExpand = false
    var tempMnemonic: String?
    var delegate: MainControllerDelegate?

    let screenSize = UIScreen.main.bounds

    let tokenView: MainTokenView = {
        let tokenView = MainTokenView()
        tokenView.translatesAutoresizingMaskIntoConstraints = false

        return tokenView
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.text = "0.000 ETH"
        label.font = UIFont(name:"NanumSquareRoundB", size: 40, dynamic: true)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let depositButton: CustomButton = {
        let button = CustomButton()

        return button
    }()

    let txView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.clearNavigationBar()
        navigationItem.title = "MOAH Wallet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Side", style: .plain, target: self, action: #selector(leftMenuClicked(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Side", style: .plain, target: self, action: #selector(rightMenuClicked(_:)))

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 25, dynamic: true)!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white]

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mainViewClicked))

        view.addSubview(txView)
        view.addSubview(tokenView)
        view.addSubview(balanceLabel)
        view.addGestureRecognizer(tap)
        tokenView.setTokenString(tokenString: "Ethereum")
        tokenView.delegate = self

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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        tokenView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight/20).isActive = true
        tokenView.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        tokenView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tokenView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        balanceLabel.topAnchor.constraint(equalTo: tokenView.bottomAnchor, constant: screenHeight/10).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenHeight/20).isActive = true
        balanceLabel.centerXAnchor.constraint(equalTo: tokenView.centerXAnchor).isActive = true
        balanceLabel.widthAnchor.constraint(equalToConstant: screenWidth/1.5).isActive = true

        txView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        txView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        txView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        txView.heightAnchor.constraint(equalToConstant: screenHeight/2.5).isActive = true
    }

    func tokenViewClicked() {

    }

    @objc func leftMenuClicked(_ sender: UIBarButtonItem){
        delegate?.leftSideMenuClicked()
    }

    @objc func rightMenuClicked(_ sender: UIBarButtonItem){
        delegate?.rightSideMenuClicked(forMenuOption: nil)
    }

    @objc func mainViewClicked(_ sender: UITapGestureRecognizer){
        delegate?.mainViewClicked()
    }

}
