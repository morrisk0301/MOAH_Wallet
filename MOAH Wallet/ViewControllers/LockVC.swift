//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class LockVC: UIViewController{

    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        let attrText = NSMutableAttributedString(string: "비밀번호를 입력해주세요",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        attrText.append(NSAttributedString(string: "\n\nMOAH Wallet 사용을 위해 비밀번호를 입력해주세요",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))

        textView.attributedText = attrText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(passwordText)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordText.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
}