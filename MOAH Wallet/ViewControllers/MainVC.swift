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

    let mainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 60))
        textView.text = "메인화면 입니다."
        textView.font = UIFont(name:"NanumSquareRoundB", size: 40)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.clearNavigationBar()
        navigationItem.title = "MOAH Wallet"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Side", style: .plain, target: self, action: #selector(leftMenuClicked(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Side", style: .plain, target: self, action: #selector(rightMenuClicked(_:)))

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 25)!,
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white]


        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))

        view.backgroundColor = .white
        view.addSubview(mainText)

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
        mainText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainText.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc func leftMenuClicked(_ sender: UIBarButtonItem){
        delegate?.leftSideMenuClicked()
    }

    @objc func rightMenuClicked(_ sender: UIBarButtonItem){
        delegate?.rightSideMenuClicked()
    }

}
