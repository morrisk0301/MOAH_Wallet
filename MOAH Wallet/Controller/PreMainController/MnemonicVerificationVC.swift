//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate{

    var wordIndex: Int?
    var isSetting = false

    let screenSize = UIScreen.main.bounds
    let util = Util()

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
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.keyboardType = .asciiCapable
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textInput(_:)), for: .editingChanged)

        return textField
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
        self.hideKeyboardWhenTappedAround()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        if(wordIndex == nil){
            wordIndex = 0
        }

        view.backgroundColor = UIColor(key: "light3")

        mnemonicField.delegate = self

        view.addSubview(headLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicProgress)
        view.addSubview(mnemonicField)
        view.addSubview(nextButton)

        self.setVar()

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.frame = CGRect(x:0, y: mnemonicField.frame.height-1, width: mnemonicField.frame.width, height: 1)
        border.backgroundColor = UIColor(key: "grey2").cgColor

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

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setVar(){
        self.mnemonicField.text = ""
        self.explainLabel.text = "\(wordIndex! + 1)번째 시드 단어를 입력해주세요."
        self.mnemonicProgress.progress = Float(wordIndex!)/12
    }

    @objc private func textInput(_ sender: UITextField) {
        let account: EthAccount = EthAccount.accountInstance
        if(account.verifyMnemonic(index: wordIndex!, word: mnemonicField.text!.lowercased())){
            if(wordIndex! < 11) {
                self.wordIndex! += 1
                self.setVar()
            }
            else{
                account.verifyAccount()
                if(isSetting){
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is MnemonicSettingVC {
                            let pViewController = aViewController as! MnemonicSettingVC
                            pViewController.isFinished = true
                            self.navigationController?.popToViewController(pViewController, animated: true)
                        }
                    }
                }else{
                    let walletDoneVC = WalletDoneVC()
                    self.present(walletDoneVC, animated: true)
                }
            }
        }
    }

    @objc private func nextPressed(_ sender: UIButton){
        let account: EthAccount = EthAccount.accountInstance
        if(account.verifyMnemonic(index: wordIndex!, word: mnemonicField.text!.lowercased())){
            if(wordIndex! < 11) {
                self.wordIndex! += 1
                self.setVar()
            }
            else{
                account.verifyAccount()
                if(isSetting){
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is MnemonicSettingVC {
                            let pViewController = aViewController as! MnemonicSettingVC
                            pViewController.isFinished = true
                            self.navigationController?.popToViewController(pViewController, animated: true)
                        }
                    }
                }else{
                    let walletDoneVC = WalletDoneVC()
                    self.present(walletDoneVC, animated: true)
                }
            }
        }
        else{
            let alertVC = util.alert(title: "시드 구문 오류", body: "올바르지 않은 시드 구문입니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in})
            self.present(alertVC, animated: false)
        }

    }
}