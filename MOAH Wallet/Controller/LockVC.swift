//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class LockVC: UIViewController, KeypadViewDelegate {

    var toView: String!
    var password:String = ""
    var count = 0
    let account: EthAccount = EthAccount.shared
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    let userDefaults = UserDefaults.standard
    let reachability = ReachabilityManager.shared

    let lock: LockView = {
        let lockView = LockView()
        lockView.translatesAutoresizingMaskIntoConstraints = false

        return lockView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.transparentNavigationBar()

        view.addSubview(lock)
        lock.secureKeypad.delegate = self

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        networkCheck(completion: {
            let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
            if (useBiometrics) {
                bioVerification()
            }
        })
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

    func networkCheck(completion: () -> ()){
        if(reachability.reachability.connection == .none){
            let alertController = UIAlertController(title: "Error".localized, message: "네트워크를 사용할 수 없습니다.\n네트워크를 활성화해주세요.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "재시도", style: .default){(_) in
                if (self.reachability.reachability.connection == .none){
                    self.networkCheck(completion: {})
                }
            }
            alertController.addAction(ok)
            self.present(alertController, animated: false)
        }
        else {
            completion()
        }
    }

    func cellPressed(_ cellItem: String) {
        password.append(cellItem)
        lock.changeLabel(password.count)

        if(password.count >= 6){
            if(account.checkPassword(password)){
                userDefaults.removeObject(forKey: "lockCount")
                let mainContainerVC = MainContainerVC()
                self.appDelegate.window?.rootViewController = mainContainerVC
            }
            else{
                count += 1
                if(count > 4){
                    self.lockUser()
                    return
                }

                password = ""
                let changeImage = UIImage(named: "pwLine")
                let animation = ShakeAnimation()
                self.view.layer.add(animation, forKey: "position")

                lock.errorLabel.text = "Invalid Password".localized + "(\(self.count)/5)\n" + "Account will be locked after 5 tries".localized
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
        autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet Biometrics Verification".localized) { (success, error) in
            DispatchQueue.main.async {
                if (success) {
                    self.userDefaults.removeObject(forKey: "lockCount")
                    self.account.bioProceed()
                    let mainContainerVC = MainContainerVC()
                    self.appDelegate.window?.rootViewController = mainContainerVC
                }
            }
        }
    }
}
