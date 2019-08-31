//
// Created by 김경인 on 2019-07-28.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class GetAccountVC: UIViewController, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.shared

    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?

    let nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  " + "Account Name".localized
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let privateKeyLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  " + "Private Key".localized
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nameField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Enter your account's name".localized
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 0

        return textField
    }()

    let privateKeyField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Enter your private key.".localized
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 1

        return textField
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "MOAH Wallet does not collect users' private key.\n\nYour private key will be securely stored into your device after being encrypted.".localized
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 15, dynamic: true)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Get Account".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "Get Account with PK".localized)
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")
        nameField.delegate = self
        nameField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        privateKeyField.delegate = self

        nameField.clearButtonMode = .whileEditing
        privateKeyField.clearButtonMode = .whileEditing

        view.addSubview(nameLabel)
        view.addSubview(privateKeyLabel)
        view.addSubview(nameField)
        view.addSubview(privateKeyField)
        view.addSubview(confirmButton)
        view.addSubview(warningLabel)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .pad {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom != .pad {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        nameField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        privateKeyLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: screenSize.height/30).isActive = true
        privateKeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privateKeyLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        privateKeyLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        privateKeyField.topAnchor.constraint(equalTo: privateKeyLabel.bottomAnchor).isActive = true
        privateKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privateKeyField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        privateKeyField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        warningLabel.topAnchor.constraint(equalTo: privateKeyField.bottomAnchor, constant: screenSize.height/30).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/6).isActive = true
        warningLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20)
        hideConstraint!.isActive = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 1){ return true}
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            if (keyboardHeight == nil) {
                keyboardHeight = keyboardRectangle.height
            }
            if (!keyboardShown || keyboardHeight! < keyboardRectangle.height) {
                if (showConstraint != nil) {
                    showConstraint!.isActive = false
                }
                showConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRectangle.height-screenSize.height/50)
                hideConstraint!.isActive = false
                showConstraint!.isActive = true
                keyboardHeight = keyboardRectangle.height
                keyboardShown = true
            }
        }
    }

    @objc private func keyboardWillHide(_ sender: Notification) {
        if (keyboardShown) {
            showConstraint!.isActive = false
            hideConstraint!.isActive = true
            keyboardShown = false
        }
    }

    @objc private func nextPressed(_ sender: UIButton){
        let util = Util()

        let name = nameField.text!.trimWhiteSpaces()
        let key = privateKeyField.text!
        var errorBody: String?

        if(name.isEmpty){
            let alertVC = util.alert(title: "Error".localized, body: "Enter your account's name".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in})
            self.present(alertVC, animated: false)
            return
        }
        do{
            let result = try account.getAccount(key: key, name: name)
            if(result){
                for controller in self.navigationController!.viewControllers{
                    guard let vc = controller as? MyAccountVC else { continue }
                    self.reloadMainContainerVC()
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }else{
                errorBody = "Duplicate account name".localized
            }
        }
        catch GetAccountError.invalidPrivateKey {
            errorBody = "Private Key is invalid.".localized
        }
        catch GetAccountError.existingAccount {
            errorBody = "Account already exists in your wallet".localized
        }
        catch{
            errorBody = "Unknown Error".localized
        }
        let alertVC = util.alert(title: "Error".localized, body: errorBody!, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in})
        self.present(alertVC, animated: false)
    }
}
