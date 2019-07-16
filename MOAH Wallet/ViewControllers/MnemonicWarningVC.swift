//
// Created by 김경인 on 2019-07-01.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicWarningVC: UIViewController {

    var tempMnemonic: String?

    let mnemonicText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        attrText.append(NSAttributedString(string: "\n\n비밀 시드 구문으로 지갑을 백업하고\n복원할 수 있습니다.",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))

        textView.attributedText = attrText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let warningText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))
        textView.text = "주의: 비밀 시드 구문을 절대 공개하지 마십시오. 시드 구문으로 사용자의 암호화폐를 탈취할 수 있습니다."
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .red
        textView.isEditable = false
        textView.textAlignment = .left
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
        self.replaceBackButton(color: "dark")
        self.clearNavigationBar()

        view.backgroundColor = .white
        view.addSubview(mnemonicText)
        view.addSubview(warningText)
        view.addSubview(nextButton)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        mnemonicText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mnemonicText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mnemonicText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mnemonicText.heightAnchor.constraint(equalToConstant: 120).isActive = true

        warningText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        warningText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        warningText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        warningText.heightAnchor.constraint(equalToConstant: 120).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc private func backPressed(_ sender: UIBarButtonItem) {
        let pMainVC = self.presentingViewController as! MainVC
        pMainVC.signUp = false
        self.dismiss(animated: true)
    }

    @objc private func nextPressed(_ sender: UIButton) {
        let mnemonicVC = MnemonicVC()
        mnemonicVC.tempMnemonic = self.tempMnemonic!

        self.navigationController?.pushViewController(mnemonicVC, animated: true)
    }
}
