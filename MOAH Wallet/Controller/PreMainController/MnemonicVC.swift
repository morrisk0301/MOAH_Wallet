//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVC: UIViewController, UIGestureRecognizerDelegate {

    var tempMnemonic: String?
    private var isCopied = false
    var isSetting = false

    let screenSize = UIScreen.main.bounds

    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "Mnemonic Phrase".localized
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 300))

        label.text = "Following text is your mnemonic phrase.".localized + "\n\n" + "Type mnemonic phrase in order to verify your wallet.".localized
        label.font = UIFont(name: "NanumSquareRoundR", size: 17, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let mnemonicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 150))

        label.text = ""
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "Mnemonic phrase is used to back up and restore your wallet.\n\nAnyone can access your wallet through mnemonic phrase. Be careful not to disclose it.\n\nMOAH Wallet does not collect users' mnemonic phrase. Your mnemonic phrase will be securely stored in to your device after being encrypted.".localized
        label.font = UIFont(name: "NanumSquareRoundR", size: 15, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("Copy Mnemonic Phrase".localized, for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(headLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicLabel)
        view.addSubview(warningLabel)
        view.addSubview(nextButton)

        var mnemonic: String!

        if(isSetting){
            let account: EthAccount = EthAccount.shared

            self.setNavigationTitle(title: "View Mnemonic Phrase".localized)
            self.replaceBackButton(color: "dark")

            headLabel.isHidden = true
            mnemonic = account.getMnemonic()
            explainLabel.text = "Following text is your mnemonic phrase.".localized

            var navCounter = 0
            for controller in self.navigationController!.viewControllers{
                if(controller is PasswordCheckVC){
                    self.navigationController?.viewControllers.remove(at: navCounter)
                }
                navCounter += 1
            }
        } else{
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.replaceToQuitButton(color: "dark")
            mnemonic = self.tempMnemonic!
        }

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attrText = NSMutableAttributedString(string: mnemonic,
                attributes: [NSAttributedString.Key.paragraphStyle: style,
                             NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 20, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
        mnemonicLabel.attributedText = attrText

        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:-screenSize.width/20, y: mnemonicLabel.frame.height+screenSize.height/100, width: mnemonicLabel.frame.width+screenSize.width/10, height: 1)
        mnemonicLabel.layer.addSublayer(border)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
        self.nextButton.setTitle("Copy Mnemonic Phrase".localized, for: .normal) 
        self.isCopied = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/40).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true

        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true

        if(isSetting){
            explainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
            explainLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true
        }else{
            explainLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: screenHeight/50).isActive = true
            explainLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }

        mnemonicLabel.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenHeight/30).isActive = true
        mnemonicLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/10).isActive = true
        mnemonicLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/10).isActive = true
        mnemonicLabel.heightAnchor.constraint(equalToConstant: screenHeight/6).isActive = true

        warningLabel.topAnchor.constraint(equalTo: mnemonicLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/4).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton) {
        if(!isCopied){
            let util = Util()
            UIPasteboard.general.string = self.mnemonicLabel.text
            let alertVC = util.alert(title: "Copy Mnemonic Phrase".localized, body: "Mnemonic phrase has been copied to clipboard.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in
                DispatchQueue.main.async{
                    if(self.isSetting){ return }
                    self.nextButton.setTitle("Verify Mnemonic Phrase".localized, for: .normal)
                    self.isCopied = true
                }
            })
            self.present(alertVC, animated: false)
        }
        else{
            let mnemonicVerificationVc = MnemonicVerificationVC()
            self.navigationController?.pushViewController(mnemonicVerificationVc, animated: true)
        }

    }
}