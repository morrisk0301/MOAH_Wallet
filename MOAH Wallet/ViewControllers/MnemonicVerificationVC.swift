//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationVC: UIViewController{

    var wordIndex: Int?

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let mnemonicProgress: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x:0, y:0, width:200, height:5))

        progressView.progressTintColor = UIColor(rgb: 0x3562FF)
        progressView.trackTintColor = UIColor(rgb: 0xEAEAFF)
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)

        progressView.translatesAutoresizingMaskIntoConstraints = false

        return progressView
    }()

    let mnemonicField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "비밀 시드 단어를 입력해주세요"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textInput(_:)), for: .editingChanged)

        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        if(wordIndex == nil){
            wordIndex = 0
        }

        view.backgroundColor = .white
        view.addSubview(explainText)
        view.addSubview(mnemonicField)
        view.addSubview(mnemonicProgress)

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문 인증",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attrText.append(NSAttributedString(string: "\n\n\(wordIndex!+1)번째 시드 단어를 입력해주세요.",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
        explainText.attributedText = attrText

        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed(_:)))

        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        mnemonicProgress.progress = Float(wordIndex!)/12

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mnemonicField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        explainText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        mnemonicProgress.topAnchor.constraint(equalTo: explainText.bottomAnchor).isActive = true
        mnemonicProgress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicProgress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicProgress.heightAnchor.constraint(equalToConstant: 5).isActive = true

        mnemonicField.topAnchor.constraint(equalTo: explainText.bottomAnchor, constant: 40).isActive = true
        mnemonicField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicField.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

                self.present(walletDoneVC, animated: true)
            }
        }
        return
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