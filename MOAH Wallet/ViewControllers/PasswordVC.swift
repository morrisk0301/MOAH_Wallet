//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Security

class PasswordVC: UIViewController, UITextFieldDelegate{

    var password: String?
    var confirm = false
    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?

    let service = "WalletPassword"
    let account = ""


    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

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
        textField.placeholder = "비밀번호 (최소 8자리 이상)"
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

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()


        view.backgroundColor = .white
        view.addSubview(passwordText)
        view.addSubview(passwordField)
        view.addSubview(confirmButton)

        if(!confirm){
            let attrText = NSMutableAttributedString(string: "비밀번호 생성",
                    attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            attrText.append(NSAttributedString(string: "\n\n비밀번호는 찾기가 불가능하므로, \n신중하게 입력해주세요.",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))

            passwordText.attributedText = attrText
        }
        else{
            let attrText = NSMutableAttributedString(string: "비밀번호 확인",
                    attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            attrText.append(NSAttributedString(string: "\n\n비밀번호를 한번 더 입력해주세요.",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))

            passwordText.attributedText = attrText
        }


        setupLayout()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        passwordField.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func setupLayout(){
        passwordText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 120).isActive = true

        passwordField.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        passwordField.leadingAnchor.constraint(equalTo:  view.leadingAnchor, constant: 20).isActive = true
        passwordField.trailingAnchor.constraint(equalTo:  view.trailingAnchor, constant: -20).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        hideConstraint!.isActive = true
    }

    private func savePassword(){
        let defaults = UserDefaults.standard
        let passwordArray: Array<UInt8> = Array("\(password!)".utf8)
        let hash = randomString(length: 32)
        let salt: Array<UInt8> = Array(hash.utf8)
        let saltString = salt.toHexString()

        let key = try? PKCS5.PBKDF2(password: passwordArray, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        let keyString = key?.toHexString()

        defaults.set(saltString, forKey: "salt")
        defaults.set(keyString, forKey: "key")
    }

    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
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
        if(!confirm){
            let passwordVC = PasswordVC()
            passwordVC.confirm = true
            passwordVC.password = self.passwordField.text!

            self.navigationController?.pushViewController(passwordVC, animated: true)
        }
        if(confirm && password == self.passwordField.text!){
            savePassword()

            let mainVC = MainVC()
            mainVC.signup = true

            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController = mainVC

            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}