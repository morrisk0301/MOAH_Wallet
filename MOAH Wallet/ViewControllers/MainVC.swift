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
    //var tempMnemonic: String = "almost cross gorilla slogan visa volcano sport output region wealth good bamboo"
    var tempMnemonic: String?

    let mainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 60))
        textView.text = "메인화면 입니다."
        textView.font = UIFont.boldSystemFont(ofSize: 40)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
            //mnemonicWarningVC.tempMnemonic = self.tempMnemonic!
            mnemonicWarningVC.tempMnemonic = self.tempMnemonic

            let navigationController = UINavigationController(rootViewController: mnemonicWarningVC)

            self.present(navigationController, animated: false)
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

}
