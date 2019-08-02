//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class PasswordVC: UIViewController, KeypadViewDelegate {

    var toView: String!
    let account: EthAccount = EthAccount.accountInstance
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    let userDefaults = UserDefaults.standard
    var getWallet: Bool = false
    var useBiometrics: Bool = false
    var password: String?
    var passwordTemp: String = ""
    var salt: String?
    var confirm = false

    let autoContext = LAContext()
    let util = Util()
    let defaults = UserDefaults.standard

    let lock: LockView = {
        let lockView = LockView()
        lockView.translatesAutoresizingMaskIntoConstraints = false

        return lockView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.transparentNavigationBar()

        view.addSubview(lock)
        lock.secureKeypad.delegate = self

        let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        if (useBiometrics) {
            bioVerification()
        }

        if(!confirm){
            lock.passwordLabel.text = "MOAH Wallet 잠금\n비밀번호를 설정해주세요."
        }
        else{
            lock.passwordLabel.text = "비밀번호를 한번 더 입력해주세요."
        }

        setupLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let changeImage = UIImage(named: "pwLine")

        lock.errorLabel.text = ""
        passwordTemp = ""

        lock.pwLine6.image = changeImage
        lock.pwLine5.image = changeImage
        lock.pwLine4.image = changeImage
        lock.pwLine3.image = changeImage
        lock.pwLine2.image = changeImage
        lock.pwLine.image = changeImage
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
        passwordTemp.append(cellItem)
        lock.changeLabel(passwordTemp.count)

        if(passwordTemp.count >= 6){
            if(!confirm){
                let passwordVC = PasswordVC()
                passwordVC.confirm = true

                if(getWallet){
                    passwordVC.getWallet = true
                }
                passwordVC.password = passwordTemp

                self.navigationController?.pushViewController(passwordVC, animated: true)
            }
            else if(confirm && password == passwordTemp){
                account.savePassword(password!)
                authBiometrics()
            }
            else if(confirm && password != passwordTemp){
                passwordTemp = ""
                let changeImage = UIImage(named: "pwLine")

                let animation = ShakeAnimation()
                self.view.layer.add(animation, forKey: "position")

                lock.errorLabel.text = "비밀번호가 일치하지 않습니다."
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
        if(passwordTemp.count > 0){
            lock.deleteLabel(passwordTemp.count)
            passwordTemp.removeLast()
        }
    }

    private func bioVerification() {
        let autoContext = LAContext()
        autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생체 인식") { (success, error) in
            DispatchQueue.main.async {
                if (success) {
                    self.account.bioProceed()
                    let mainContainerVC = MainContainerVC()
                    self.appDelegate.window?.rootViewController = mainContainerVC
                }
            }
        }
    }

    private func proceedView(){
        self.defaults.set(self.useBiometrics, forKey: "useBiometrics")

        if(self.getWallet){
            let walletDoneVC = WalletDoneVC()

            if(self.account.setAccount()){
                account.verifyAccount()
                walletDoneVC.getWallet = true
                self.present(walletDoneVC, animated: true)
            }
        }
        else{
            let mnemonic = self.account.generateMnemonic()

            let mainContainerVC = MainContainerVC()
            mainContainerVC.signUp = true
            mainContainerVC.tempMnemonic = mnemonic

            if(self.account.setAccount()){
                let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

                appDelegate.window?.rootViewController = mainContainerVC
            }
        }
    }

    private func authBiometrics(){
        if(autoContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)){
            let alertVC = util.alert(title: "생체 인식 기능 사용", body: "빠른 앱 실행을 위해\n생체 인식 기능을 사용하시겠습니까?", buttonTitle: "사용하기", buttonNum: 2){(next) in
                if(next){
                    self.autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생체 인식"){(success, error) in
                        DispatchQueue.main.async {
                            if (success) {
                                self.useBiometrics = true
                            }
                            self.proceedView()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.proceedView()
                    }
                }
            }
            self.present(alertVC, animated: false)
        }else{
            DispatchQueue.main.async {
                self.proceedView()
            }
        }
    }
}
