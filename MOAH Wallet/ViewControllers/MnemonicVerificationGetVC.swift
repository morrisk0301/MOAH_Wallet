//
// Created by 김경인 on 2019-07-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationGetVC: UIViewController, UITextViewDelegate {

    let screenSize = UIScreen.main.bounds

    let mnemonicText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))

        textView.text = "비밀 시드 구문 인증"
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        textView.text = "복원하실 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요."
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let mnemonicField: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 200))

        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.returnKeyType = .done
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = .white
        view.addSubview(mnemonicText)
        view.addSubview(explainText)
        view.addSubview(mnemonicField)
        view.addSubview(nextButton)

        mnemonicField.delegate = self

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
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
        mnemonicText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: 30).isActive = true

        explainText.topAnchor.constraint(equalTo: mnemonicText.bottomAnchor).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainText.bottomAnchor, constant: 20).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: screenSize.height/4.5).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton){
        let passwordVC = PasswordVC()
        let account: EthAccount = EthAccount.accountInstance

        if(account.setMnemonic(mnemonicString: mnemonicField.text!)){
            passwordVC.getWallet = true
            self.navigationController?.pushViewController(passwordVC, animated: true)
        }

    }
}