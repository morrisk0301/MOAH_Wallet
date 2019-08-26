//
// Created by 김경인 on 2019-07-28.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {

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

        return textField
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Create Account".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "Create Account".localized)
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")
        nameField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        nameField.delegate = self

        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(confirmButton)

        nameField.clearButtonMode = .whileEditing

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
        nameField.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenSize.height/4).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        nameField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20)
        hideConstraint!.isActive = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        let name = nameField.text!
        if(nameField.text?.count == 0){
            let alertVC = util.alert(title: "Error".localized, body: "Enter your account's name".localized, buttonTitle: "확인", buttonNum: 1, completion: {_ in})
            self.present(alertVC, animated: false)
        }
        else if(account.generateAccount(name: name)){
            for controller in self.navigationController!.viewControllers{
                guard let vc = controller as? MyAccountVC else { continue }
                self.reloadMainContainerVC()
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        else{
            let alertVC = util.alert(title: "Error".localized, body: "Duplicate account name or exceeded maximum account number".localized, buttonTitle: "확인", buttonNum: 1, completion: {_ in})
            self.present(alertVC, animated: false)
        }
    }
}
