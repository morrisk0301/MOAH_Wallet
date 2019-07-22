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
        textView.font = UIFont(name:"NanumSquareRoundB", size: 20)
        textView.textColor = UIColor(key: "darker")
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        textView.text = "복원하실 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요."
        textView.font = UIFont(name:"NanumSquareRoundR", size: 16)
        textView.textColor = UIColor(key: "darker")
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let mnemonicField: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 200))

        textView.layer.borderColor = UIColor(key: "darker").cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont(name:"NanumSquareRoundB", size: 20)
        textView.textColor = UIColor(key: "darker")
        textView.returnKeyType = .done
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardType = .asciiCapable

        return textView
    }()

    let errorText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.text = ""
        textView.font = UIFont(name:"NanumSquareRoundB", size: 14)
        textView.backgroundColor = .clear
        textView.textColor = UIColor(key: "darker")
        textView.isEditable = false
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    let animation: CABasicAnimation = {
        let midX = UIScreen.main.bounds.midX
        let midY = UIScreen.main.bounds.midY
        let animation = CABasicAnimation(keyPath: "position")

        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)

        return animation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = .white
        view.addSubview(mnemonicText)
        view.addSubview(explainText)
        view.addSubview(mnemonicField)
        view.addSubview(errorText)
        view.addSubview(nextButton)

        mnemonicField.delegate = self

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        mnemonicField.text = ""
        errorText.text = ""
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

        mnemonicText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: 30).isActive = true

        explainText.topAnchor.constraint(equalTo: mnemonicText.bottomAnchor, constant: screenHeight/40).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainText.bottomAnchor, constant: screenHeight/30).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: screenSize.height/4.5).isActive = true

        errorText.topAnchor.constraint(equalTo: mnemonicField.bottomAnchor, constant: 5).isActive = true
        errorText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
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
            self.view.layer.add(animation, forKey: "position")
            errorText.text = "올바르지 않은 시드 구문입니다!"
        }

    }
}