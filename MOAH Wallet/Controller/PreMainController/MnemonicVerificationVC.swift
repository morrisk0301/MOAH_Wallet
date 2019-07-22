//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationVC: UIViewController{

    var wordIndex: Int?

    let screenSize = UIScreen.main.bounds

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let mnemonicProgress: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x:0, y:0, width:200, height:5))

        progressView.progressTintColor = UIColor(key: "regular")
        progressView.trackTintColor = UIColor(key: "light")
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)

        progressView.translatesAutoresizingMaskIntoConstraints = false

        return progressView
    }()

    let mnemonicField: UITextField = {
        let textField = UITextField()


        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "비밀 시드 단어를 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 20)
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textInput(_:)), for: .editingChanged)

        return textField
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
        self.hideKeyboardWhenTappedAround()
        self.clearNavigationBar()
        self.replaceBackButton(color: "dark")

        if(wordIndex == nil){
            wordIndex = 0
        }

        view.backgroundColor = .white
        view.addSubview(explainText)
        view.addSubview(mnemonicProgress)
        view.addSubview(mnemonicField)
        view.addSubview(errorText)
        view.addSubview(nextButton)

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문 인증",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
        attrText.append(NSAttributedString(string: "\n\n\(wordIndex!+1)번째 시드 단어를 입력해주세요.",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 18), 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))
        explainText.attributedText = attrText

        mnemonicProgress.progress = Float(wordIndex!)/12

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.frame = CGRect(x:0, y: mnemonicField.frame.height-1, width: mnemonicField.frame.width, height: 1)
        border.backgroundColor = UIColor(key: "darker").cgColor

        mnemonicField.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        explainText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 100).isActive = true

        mnemonicProgress.topAnchor.constraint(equalTo: explainText.bottomAnchor).isActive = true
        mnemonicProgress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicProgress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicProgress.heightAnchor.constraint(equalToConstant: 5).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainText.bottomAnchor, constant: screenHeight/7).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        errorText.topAnchor.constraint(equalTo: mnemonicField.bottomAnchor, constant: 5).isActive = true
        errorText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func textInput(_ sender: UITextField) {
        let account: EthAccount = EthAccount.accountInstance
        if(account.verifyMnemonic(index: wordIndex!, word: mnemonicField.text!)){
            if(wordIndex! < 11) {
                let mnemonicVerificationVC = MnemonicVerificationVC()
                mnemonicVerificationVC.wordIndex = wordIndex! + 1
                self.navigationController?.pushViewController(mnemonicVerificationVC, animated: false)
            }
            else{
                let walletDoneVC = WalletDoneVC()
                if(account.setAccount()){
                    self.present(walletDoneVC, animated: true)
                }
            }
        }
        return
    }

    @objc private func nextPressed(_ sender: UIButton){
        let account: EthAccount = EthAccount.accountInstance
        if(account.verifyMnemonic(index: wordIndex!, word: mnemonicField.text!)){
            if(wordIndex! < 11) {
                let mnemonicVerificationVC = MnemonicVerificationVC()
                mnemonicVerificationVC.wordIndex = wordIndex! + 1
                self.navigationController?.pushViewController(mnemonicVerificationVC, animated: false)
            }
            else{
                let walletDoneVC = WalletDoneVC()
                if(account.setAccount()){
                    self.present(walletDoneVC, animated: true)
                }
            }
        }
        else{
            self.view.layer.add(animation, forKey: "position")
            errorText.text = "올바르지 않은 시드 구문입니다!"
        }

    }

    @objc private func backPressed(_ sender: UIButton){
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is MnemonicVC {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
}