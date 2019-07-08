//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVerificationVC: UIViewController{

    var getWallet = false

    let explainText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

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

        let attrText = NSMutableAttributedString(string: "비밀 시드 구문 인증",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        if(!getWallet){
            attrText.append(NSAttributedString(string: "\n\n회원님의 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
        }
        else{
            attrText.append(NSAttributedString(string: "\n\n복원하실 지갑의 12자리 비밀 시드 구문을 순서대로 입력해주세요",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
        }
        explainText.attributedText = attrText

        view.backgroundColor = .white
        view.addSubview(explainText)
        view.addSubview(nextButton)

        setupLayout()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        explainText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        explainText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        explainText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        explainText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton) {
        if(getWallet){
            let passwordVC = PasswordVC()
            passwordVC.getWallet = true
            self.navigationController?.pushViewController(passwordVC, animated: true)
        }
        else{
            let walletDoneVC = WalletDoneVC()
            self.present(walletDoneVC, animated: true)
        }

    }
}