//
// Created by 김경인 on 2019-07-28.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.accountInstance

    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?

    let nameField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "계정 이름을 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "계정 생성")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")
        nameField.delegate = self

        view.addSubview(nameField)
        view.addSubview(confirmButton)

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
        let border = CALayer()
        border.frame = CGRect(x:0, y: nameField.frame.height-1, width: nameField.frame.width, height: 1)
        border.backgroundColor = UIColor(key: "grey2").cgColor

        nameField.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        nameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenSize.height/4).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        nameField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        hideConstraint!.isActive = true
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
        let name = nameField.text!
        if(account.generateAccount(name: name)){
            for controller in self.navigationController!.viewControllers{
                guard let vc = controller as? MyAccountVC else { continue }
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        else{
            let animation = ShakeAnimation()
            self.view.layer.add(animation, forKey: "position")
            //errorLabel.text = "올바르지 않은 시드 구문입니다!"
        }
    }
}
