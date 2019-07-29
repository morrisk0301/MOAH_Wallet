//
// Created by 김경인 on 2019-07-28.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class GetAccountVC: UIViewController, UITextFieldDelegate {

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
        textField.tag = 0

        return textField
    }()

    let privateKeyField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "개인키를 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 1

        return textField
    }()

    let errorLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.backgroundColor = .clear
        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "MOAH Wallet은 사용자의 개인키를 저장하지 않습니다. 개인키는 암호화 되어 안전하게 보관됩니다."
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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
        self.setNavigationTitle(title: "개인키로 가져오기")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")
        nameField.delegate = self
        nameField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        privateKeyField.delegate = self

        view.addSubview(nameField)
        view.addSubview(privateKeyField)
        view.addSubview(errorLabel)
        view.addSubview(confirmButton)
        view.addSubview(warningLabel)

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

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.frame = CGRect(x:0, y: nameField.frame.height-1, width: nameField.frame.width, height: 1)
        border.backgroundColor = UIColor(key: "grey2").cgColor

        let border2 = CALayer()
        border2.frame = CGRect(x:0, y: privateKeyField.frame.height-1, width: privateKeyField.frame.width, height: 1)
        border2.backgroundColor = UIColor(key: "grey2").cgColor

        nameField.layer.addSublayer(border)
        privateKeyField.layer.addSublayer(border2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        nameField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        privateKeyField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: screenSize.height/40).isActive = true
        privateKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privateKeyField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        privateKeyField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        errorLabel.topAnchor.constraint(equalTo: privateKeyField.bottomAnchor, constant: screenSize.height/200).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        warningLabel.topAnchor.constraint(equalTo: privateKeyField.bottomAnchor, constant: screenSize.height/20).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/10).isActive = true
        warningLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
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
        let key = privateKeyField.text!
        let animation = ShakeAnimation()
        do{
            let result = try account.getAccount(key: key, name: name)
            if(result){
                for controller in self.navigationController!.viewControllers{
                    guard let vc = controller as? MyAccountVC else { continue }
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }else{
                errorLabel.text = "계정 이름이 중복되었습니다."
                self.view.layer.add(animation, forKey: "position")
            }
        }
        catch GetAccountError.invalidPrivateKey {
            errorLabel.text = "올바르지 않은 개인키입니다."
            self.view.layer.add(animation, forKey: "position")
        }
        catch GetAccountError.existingAccount {
            errorLabel.text = "이미 존재하는 계정입니다."
            self.view.layer.add(animation, forKey: "position")
        }
        catch{
            errorLabel.text = "계정 오류입니다."
            self.view.layer.add(animation, forKey: "position")
        }
    }
}
