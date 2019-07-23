//
// Created by 김경인 on 2019-07-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationGetVC: UIViewController, UITextViewDelegate {

    let screenSize = UIScreen.main.bounds

    let mnemonicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 30))

        label.text = "비밀 시드 구문 인증"
        label.font = UIFont(name:"NanumSquareRoundB", size: 20)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.text = "복원하실 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요."
        label.font = UIFont(name:"NanumSquareRoundR", size: 16)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let mnemonicField: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 200))

        textView.layer.borderColor = UIColor(key: "darker").cgColor
        textView.layer.borderWidth = 1.0
        textView.font = UIFont(name:"NanumSquareRoundB", size: 20)
        textView.textColor = UIColor(key: "darker")
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.keyboardType = .asciiCapable

        return textView
    }()

    let errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.text = ""
        label.font = UIFont(name:"NanumSquareRoundB", size: 14)
        label.backgroundColor = .clear
        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
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

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(mnemonicLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicField)
        view.addSubview(errorLabel)
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
        errorLabel.text = ""
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
        mnemonicLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        explainLabel.topAnchor.constraint(equalTo: mnemonicLabel.bottomAnchor, constant: screenHeight/40).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenHeight/30).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: screenSize.height/4.5).isActive = true

        errorLabel.topAnchor.constraint(equalTo: mnemonicField.bottomAnchor, constant: 5).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

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
            errorLabel.text = "올바르지 않은 시드 구문입니다!"
        }

    }
}