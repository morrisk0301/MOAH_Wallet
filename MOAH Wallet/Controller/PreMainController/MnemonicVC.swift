//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVC: UIViewController {

    var tempMnemonic: String?

    let screenSize = UIScreen.main.bounds

    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "비밀 시드 구문"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 300))

        label.text = "다음은 회원님의 비밀 시드 구문입니다.\n\n비밀 시드 구문을 순서대로 입력하여, 지갑 인증을 진행해 주세요."
        label.font = UIFont(name: "NanumSquareRoundR", size: 17, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let mnemonicText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 150))

        textView.textAlignment = .left
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(key: "darker").cgColor
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
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
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(headLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicText)
        view.addSubview(nextButton)

        let mnemonic: String = tempMnemonic!

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attrText = NSMutableAttributedString(string: mnemonic,
                attributes: [NSAttributedString.Key.paragraphStyle: style,
                             NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 20, dynamic: true), 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
        mnemonicText.attributedText = attrText

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        explainLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: screenHeight/50).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true

        mnemonicText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: screenHeight/5).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton) {
        let mnemonicVerificationVc = MnemonicVerificationVC()
        self.navigationController?.pushViewController(mnemonicVerificationVc, animated: true)
    }
}