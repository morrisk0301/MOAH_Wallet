//
// Created by 김경인 on 2019-07-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationGetVC: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {

    let screenSize = UIScreen.main.bounds

    let mnemonicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 30))

        label.text = "비밀 시드 구문 인증"
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.text = "복원하실 지갑의 12자리 비밀 시드 구문을 띄어쓰기 포함하여 순서대로 입력해주세요."
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let mnemonicField: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 200))

        textView.layer.borderColor = UIColor(key: "darker").cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        textView.textColor = UIColor(key: "darker")
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardType = .asciiCapable

        return textView
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "비밀 시드 구문으로 기존 계정을 복원할 수 있습니다.\n\nMOAH Wallet은 사용자의 개인키 정보를 수집하지 않으며, 개인키 정보는 암호화 되어 안전하게 저장됩니다."
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(mnemonicLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicField)
        view.addSubview(warningLabel)
        view.addSubview(nextButton)

        mnemonicField.delegate = self

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        mnemonicField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    private func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        mnemonicLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mnemonicLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        explainLabel.topAnchor.constraint(equalTo: mnemonicLabel.bottomAnchor).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenHeight/30).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: screenSize.height/6).isActive = true

        warningLabel.topAnchor.constraint(equalTo: mnemonicField.bottomAnchor, constant: screenHeight/40).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/8).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton){
        let passwordVC = PasswordVC()
        let account: EthAccount = EthAccount.accountInstance

        if(account.setMnemonic(mnemonicString: mnemonicField.text!)){
            passwordVC.getWallet = true
            self.navigationController?.pushViewController(passwordVC, animated: true)
        }
        else{
            let util = Util()
            let alertVC = util.alert(title: "시드 구문 오류", body: "올바르지 않은 시드 구문입니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in})
            self.present(alertVC, animated: false)
        }

    }
}