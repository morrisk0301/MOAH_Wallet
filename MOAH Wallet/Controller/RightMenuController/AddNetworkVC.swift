//
// Created by 김경인 on 2019-08-04.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AddNetworkVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3

    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?

    let nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  네트워크 이름"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let urlLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  RPC URL"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nameField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "네트워크 이름을 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 0

        return textField
    }()

    let urlField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "ex) http://0.0.0.0:7545"
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

        label.text = "MOAH Wallet은 RPC URL을 활용한 사용자 지정 블록체인 망 접근 기능을 제공합니다.\n\n사용자 지정 네트워크(Ganache, Local, Private 등)의 암호화폐를 관리할 수 있습니다."
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("추가하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "네트워크 추가")
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        view.backgroundColor = UIColor(key: "light3")
        nameField.delegate = self
        nameField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        urlField.delegate = self

        view.addSubview(nameLabel)
        view.addSubview(nameField)
        view.addSubview(urlLabel)
        view.addSubview(urlField)
        view.addSubview(warningLabel)
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

        urlLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: screenSize.height/30).isActive = true
        urlLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        urlLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        urlLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        urlField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor).isActive = true
        urlField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        urlField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        urlField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        warningLabel.topAnchor.constraint(equalTo: urlField.bottomAnchor, constant: screenSize.height/30).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/6).isActive = true
        warningLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        return count <= 18
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
                showConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRectangle.height)
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

    @objc private func nextPressed(_ sender:UIButton){
        self.showSpinner()
        let util = Util()
        let name = nameField.text!
        let url = urlField.text!
        var errorBody: String?

        DispatchQueue.global(qos: .userInitiated).async{
            do{
                if(name.count == 0){throw AddNetworkError.invalidName}
                guard let url = URL(string: url.lowercased()) else { throw AddNetworkError.invalidURL }
                try self.web3.setNetwork(name: name, url: url, new: true)
                DispatchQueue.main.async{
                    self.navigationController?.popViewController(animated: true)
                }
            }
            catch AddNetworkError.invalidURL{
                errorBody = "올바르지 않은 URL 형식입니다."
            }
            catch AddNetworkError.invalidName {
                errorBody = "네트워크 이름이 중복되었거나,\n사용할 수 없는 네트워크 이름입니다."
            }
            catch AddNetworkError.invalidNetwork{
                errorBody = "네트워크에 연결할 수 없습니다."
            }
            catch{
                print(error)
            }
            if(errorBody != nil){
                DispatchQueue.main.async{
                    let alertVC = util.alert(title: "네트워크 추가 오류", body: errorBody!, buttonTitle: "확인", buttonNum: 1, completion: {_ in
                        self.hideSpinner()
                    })
                    self.present(alertVC, animated: false)
                }
            }
        }

    }
}
