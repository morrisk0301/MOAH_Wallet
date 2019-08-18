//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import LocalAuthentication

class PasswordCheckVC: UIViewController, KeypadViewDelegate, UIGestureRecognizerDelegate {

    var toView: String!
    var password:String = ""
    var tempTx: WriteTransaction?
    var subInfo: TXSubInfo?
    let account: EthAccount = EthAccount.accountInstance
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    let userDefaults = UserDefaults.standard

    let lock: LockView = {
        let lockView = LockView()
        lockView.translatesAutoresizingMaskIntoConstraints = false

        return lockView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.toView == "mnemonic" || self.toView == "transfer"){
            self.replaceBackButton(color: "light")
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }else{
            self.replaceToQuitButton(color: "light")
        }
        self.transparentNavigationBar()

        view.addSubview(lock)
        lock.secureKeypad.delegate = self

        let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        if (useBiometrics) {
            bioVerification()
        }

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        lock.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lock.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lock.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lock.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func cellPressed(_ cellItem: String) {
        password.append(cellItem)
        lock.changeLabel(password.count)

        if(password.count >= 6){
            if(account.checkPassword(password)){
                if(self.toView == "mnemonic"){
                    let controller = MnemonicVC()
                    controller.isSetting = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else if(self.toView == "password"){
                    let controller = PasswordSettingVC()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else if(self.toView == "privateKey"){
                    let controller = PrivateKeyVC()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else if(self.toView == "transfer"){
                    proceedTransfer()
                }
            }
            else{
                password = ""
                let changeImage = UIImage(named: "pwLine")
                let animation = ShakeAnimation()
                self.view.layer.add(animation, forKey: "position")

                lock.errorLabel.text = "비밀번호가 일치하지 않습니다.\n5회 오류시 지갑이 초기화됩니다."
                lock.pwLine6.image = changeImage
                lock.pwLine5.image = changeImage
                lock.pwLine4.image = changeImage
                lock.pwLine3.image = changeImage
                lock.pwLine2.image = changeImage
                lock.pwLine.image = changeImage
            }
        }
    }

    func delPressed() {
        if(password.count > 0){
            lock.deleteLabel(password.count)
            password.removeLast()
        }
    }

    private func bioVerification() {
        let autoContext = LAContext()
        autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생체인식") { (success, error) in
            DispatchQueue.main.async {
                if (success) {
                    if(self.toView == "mnemonic"){
                        let controller = MnemonicVC()
                        controller.isSetting = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if(self.toView == "password"){
                        let controller = PasswordSettingVC()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if(self.toView == "privateKey"){
                        let controller = PrivateKeyVC()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else if(self.toView == "transfer"){
                        self.proceedTransfer()
                    }
                }
            }
        }
    }

    private func proceedTransfer(){
        let web3: CustomWeb3 = CustomWeb3.web3
        web3.transfer(tx: tempTx!, subInfo: self.subInfo!)

        let controller = WalletDoneVC()
        controller.isTransfer = true
        self.present(controller, animated: true)
    }
}
