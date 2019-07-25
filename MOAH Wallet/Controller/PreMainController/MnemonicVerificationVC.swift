//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationVC: UIViewController{

    var wordIndex: Int?

    let screenSize = UIScreen.main.bounds

    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "비밀 시드 구문 인증"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.font = UIFont(name: "NanumSquareRoundR", size: 18, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
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
        textField.font = UIFont(name:"NanumSquareRoundR", size: 20, dynamic: true)
        textField.keyboardType = .asciiCapable
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textInput(_:)), for: .editingChanged)

        return textField
    }()

    let errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.text = ""
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.backgroundColor = .clear
        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

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

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        if(wordIndex == nil){
            wordIndex = 0
        }

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(headLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicProgress)
        view.addSubview(mnemonicField)
        view.addSubview(errorLabel)
        view.addSubview(nextButton)

        explainLabel.text = "\(wordIndex! + 1)번째 시드 단어를 입력해주세요."

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

        headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        explainLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicProgress.topAnchor.constraint(equalTo: explainLabel.bottomAnchor).isActive = true
        mnemonicProgress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/13).isActive = true
        mnemonicProgress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/13).isActive = true
        mnemonicProgress.heightAnchor.constraint(equalToConstant: 5).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenHeight/10).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        errorLabel.topAnchor.constraint(equalTo: mnemonicField.bottomAnchor, constant: 5).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

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
            errorLabel.text = "올바르지 않은 시드 구문입니다!"
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