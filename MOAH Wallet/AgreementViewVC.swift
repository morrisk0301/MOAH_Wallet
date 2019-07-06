//
// Created by 김경인 on 2019-07-04.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AgreementViewVC: UIViewController{

    var agreementNum: Int = 0
    var agreementString : String?

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)

        return button
    }()

    let agreementHead: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "MOAH Wallet 약관"
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let agreement: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 150))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(agreementHead)
        view.addSubview(agreement)

        setAgreementText()
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        agreementHead.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        agreementHead.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        agreementHead.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        agreementHead.heightAnchor.constraint(equalToConstant: 30).isActive = true

        agreement.topAnchor.constraint(equalTo: agreementHead.bottomAnchor).isActive = true
        agreement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        agreement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        agreement.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    private func setAgreementText(){
        if(agreementNum == 1){
            agreementString = "약관1 예시 약관1 예시 약관1 예시 약관1 예시 약관1 예시 약관1 예시 약관1 예시 "
        }
        else if(agreementNum == 2){
            agreementString = "약관2 예시 약관2 예시 약관2 예시 약관2 예시 약관2 예시 약관2 예시 약관2 예시 "
        }
        else if(agreementNum == 3){
            agreementString = "약관3 예시 약관3 예시 약관3 예시 약관3 예시 약관3 예시 약관3 예시 약관3 예시 "
        }

        let attrText = NSMutableAttributedString(string: "제 1장 환영합니다!",
                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        attrText.append(NSAttributedString(string: "\n\n제1조 (목적)",
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
        attrText.append(NSAttributedString(string: "\n\n"+agreementString!,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))

        agreement.attributedText = attrText
    }

    @objc private func backPressed(_ sender: UIButton){
        self.dismiss(animated: true);
    }
}