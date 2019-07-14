//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class LockVC: UIViewController, PostDelegate {

    let screenSize = UIScreen.main.bounds

    let userDefaults = UserDefaults.standard
    let account: EthAccount = EthAccount.accountInstance
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.text = "MOAH Wallet 잠금\n비밀번호를 입력해주세요"
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    let tempLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let secureKeypad: KeypadViewController = {
        let view = KeypadViewController()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        if (useBiometrics) {
            //bioVerification()
        }

        view.backgroundColor = .white
        view.addSubview(passwordText)
        view.addSubview(tempLabel)
        view.addSubview(secureKeypad)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        passwordText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        tempLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/5).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/5).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/5).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        secureKeypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/10).isActive = true
        secureKeypad.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        secureKeypad.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        secureKeypad.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
    }

    func cellPressed(cellItem: String) {
        print(cellItem)
    }

    private func bioVerification() {
        let autoContext = LAContext()
        autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생채 인식") { (success, error) in
            DispatchQueue.main.async {
                if (success) {
                    self.account.bioProceed()
                    let mainVC = MainVC()

                    self.appDelegate.window?.rootViewController = mainVC
                    self.view.window!.rootViewController?.dismiss(animated: true)
                }
            }
        }
    }
}