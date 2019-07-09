//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVC: UIViewController {

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 150))

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attrText.append(NSAttributedString(
                string: "\n\n다음은 회원님의 비밀 시드 구문입니다.\n\n비밀 시드 구문을 순서대로 입력하여, 지갑 인증을 진행해 주세요",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))

        textView.attributedText = attrText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let mnemonicText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 200))

        textView.isEditable = false
        textView.textAlignment = .left
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
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

        view.backgroundColor = .white
        view.addSubview(explainText)
        view.addSubview(mnemonicText)
        view.addSubview(nextButton)

        let mnemonic: String = getMnemonic()!

        let attrText = NSMutableAttributedString(string: mnemonic,
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        mnemonicText.attributedText = attrText

        setupLayout()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        explainText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        mnemonicText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: 200).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func getMnemonic() -> String? {
        let account = EthAccount()
        let mnemonic = account.generateMnemonic()

        return mnemonic
    }

    @objc private func nextPressed(_ sender: UIButton) {
        let mnemonicVerificationVc = MnemonicVerificationVC()
        self.navigationController?.pushViewController(mnemonicVerificationVc, animated: true)
    }
}