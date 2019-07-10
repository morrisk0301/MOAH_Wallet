//
// Created by 김경인 on 2019-07-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationGetVC: UIViewController {

    let mnemonicText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문 인증",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attrText.append(NSAttributedString(string: "\n\n회원님의 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))

        textView.attributedText = attrText
        textView.isEditable = false
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
        view.addSubview(mnemonicText)
        view.addSubview(nextButton)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        mnemonicText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: 120).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton){
        let passwordVC = PasswordVC()
        passwordVC.getWallet = true
        self.navigationController?.pushViewController(passwordVC, animated: true)
    }
}