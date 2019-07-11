//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class LockVC: UIViewController, UITextFieldDelegate{

    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?
    var key: String?

    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        let attrText = NSMutableAttributedString(string: "비밀번호를 입력해주세요",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        attrText.append(NSAttributedString(string: "\n\nMOAH Wallet 사용을 위해 비밀번호를 입력해주세요",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))

        textView.attributedText = attrText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let passwordField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "비밀번호 입력"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = .white
        view.addSubview(passwordText)
        view.addSubview(passwordField)
        view.addSubview(confirmButton)

        /*
        let account: EthAccount = EthAccount.accountInstance
        account.unlockAccount(password: "123")
        let keyStore = account.getKeyStoreManager()
        print(type(of: keyStore))
        */

        passwordField.delegate = self

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        passwordText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        passwordField.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        passwordField.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        hideConstraint!.isActive = true
    }

    private func checkPassword(_ password: String) -> Bool{
        let defaults = UserDefaults.standard

        let saltString = defaults.string(forKey: "salt")!
        let keyHex = defaults.string(forKey: "key")!

        let salt: [UInt8] = Array(saltString.utf8)
        let password: [UInt8] = Array(password.utf8)
        let key = Array<UInt8>(hex: keyHex)

        let passwordHash = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        self.key = key.toHexString()

        return (passwordHash == key)
    }

    @objc private func keyboardWillShow(_ sender: Notification){
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            if(keyboardHeight == nil){
                keyboardHeight = keyboardRectangle.height
            }
            if(!keyboardShown || keyboardHeight! < keyboardRectangle.height){
                if(showConstraint != nil){
                    showConstraint!.isActive = false
                }
                showConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRectangle.height)
                hideConstraint!.isActive = false
                showConstraint!.isActive = true
                keyboardHeight = keyboardRectangle.height
                keyboardShown = true
            }
        }
    }

    @objc private func keyboardWillHide(_ sender: Notification){
        if(keyboardShown){
            showConstraint!.isActive = false
            hideConstraint!.isActive = true
            keyboardShown = false
        }
    }

    @objc private func nextPressed(_ sender: UIButton){
        if(checkPassword(passwordField.text!)){
            let account: EthAccount = EthAccount.accountInstance
            let mainVC = MainVC()
            account.unlockAccount(key!)

            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController = mainVC
            self.view.window!.rootViewController?.dismiss(animated: false)
        }
    }
}