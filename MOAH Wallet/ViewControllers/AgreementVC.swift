//
// Created by 김경인 on 2019-07-04.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AgreementVC: UIViewController {

    var getWallet = false

    let agreementText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 60))
        textView.text = "MOAH Wallet \n서비스 약관에 동의해주세요"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let agreementCheckbox1: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(checkboxPressed(_:)), for: .touchUpInside)

        return checkbox
    }()

    let agreementCheckbox2: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        return checkbox
    }()

    let agreementCheckbox3: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        return checkbox
    }()

    let agreementCheckbox4: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        return checkbox
    }()

    let checkboxText1: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "모두 동의합니다."
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.layer.borderColor = UIColor.lightGray.cgColor
        //textView.layer.borderWidth = 1.0
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let checkboxText2: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "[필수] 약관 예시1"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let checkboxText3: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "[필수] 약관 예시2"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let checkboxText4: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "[선택] 약관 예시3"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let agreementButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(agreementPressed(_:)), for: .touchUpInside)

        return button
    }()

    let agreementButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(agreementPressed(_:)), for: .touchUpInside)

        return button
    }()

    let agreementButton3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        button.addTarget(self, action: #selector(agreementPressed(_:)), for: .touchUpInside)

        return button
    }()

    let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("동의", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(agreePressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backPressed(_:)))
        self.navigationItem.leftBarButtonItem = rightButton

        view.backgroundColor = .white
        view.addSubview(agreementText)
        view.addSubview(agreementCheckbox1)
        view.addSubview(agreementCheckbox2)
        view.addSubview(agreementCheckbox3)
        view.addSubview(agreementCheckbox4)
        view.addSubview(checkboxText1)
        view.addSubview(checkboxText2)
        view.addSubview(checkboxText3)
        view.addSubview(checkboxText4)
        view.addSubview(agreementButton1)
        view.addSubview(agreementButton2)
        view.addSubview(agreementButton3)
        view.addSubview(agreeButton)

        setupLayout()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        agreementText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        agreementText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        agreementText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementText.heightAnchor.constraint(equalToConstant: 60).isActive = true

        agreementCheckbox1.topAnchor.constraint(equalTo: agreementText.bottomAnchor, constant: 40).isActive = true
        agreementCheckbox1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        agreementCheckbox1.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox1.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxText1.topAnchor.constraint(equalTo: agreementText.bottomAnchor, constant: 40).isActive = true
        checkboxText1.leadingAnchor.constraint(equalTo: agreementCheckbox1.trailingAnchor, constant: 10).isActive = true
        checkboxText1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        checkboxText1.heightAnchor.constraint(equalToConstant: 30).isActive = true

        agreementCheckbox2.topAnchor.constraint(equalTo: agreementCheckbox1.bottomAnchor, constant: 60).isActive = true
        agreementCheckbox2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        agreementCheckbox2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox2.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxText2.topAnchor.constraint(equalTo: checkboxText1.bottomAnchor, constant: 60).isActive = true
        checkboxText2.leadingAnchor.constraint(equalTo: agreementCheckbox2.trailingAnchor, constant: 10).isActive = true
        checkboxText2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkboxText2.widthAnchor.constraint(equalToConstant: 180).isActive = true

        agreementButton1.topAnchor.constraint(equalTo: checkboxText1.bottomAnchor, constant: 60).isActive = true
        agreementButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementButton1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agreementButton1.widthAnchor.constraint(equalToConstant: 30).isActive = true

        agreementCheckbox3.topAnchor.constraint(equalTo: agreementCheckbox2.bottomAnchor, constant: 30).isActive = true
        agreementCheckbox3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        agreementCheckbox3.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox3.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxText3.topAnchor.constraint(equalTo: checkboxText2.bottomAnchor, constant: 30).isActive = true
        checkboxText3.leadingAnchor.constraint(equalTo: agreementCheckbox3.trailingAnchor, constant: 10).isActive = true
        checkboxText3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkboxText3.widthAnchor.constraint(equalToConstant: 180).isActive = true

        agreementButton2.topAnchor.constraint(equalTo: checkboxText2.bottomAnchor, constant: 30).isActive = true
        agreementButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementButton2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agreementButton2.widthAnchor.constraint(equalToConstant: 30).isActive = true

        agreementCheckbox4.topAnchor.constraint(equalTo: agreementCheckbox3.bottomAnchor, constant: 30).isActive = true
        agreementCheckbox4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        agreementCheckbox4.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox4.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxText4.topAnchor.constraint(equalTo: checkboxText3.bottomAnchor, constant: 30).isActive = true
        checkboxText4.leadingAnchor.constraint(equalTo: agreementCheckbox4.trailingAnchor, constant: 10).isActive = true
        checkboxText4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkboxText4.widthAnchor.constraint(equalToConstant: 180).isActive = true

        agreementButton3.topAnchor.constraint(equalTo: checkboxText3.bottomAnchor, constant: 30).isActive = true
        agreementButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementButton3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        agreementButton3.widthAnchor.constraint(equalToConstant: 30).isActive = true

        agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        agreeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        agreeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        agreeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func agreementPressed(_ sender: UIButton!){
        let agreementViewVC = AgreementViewVC()
        let button = sender as UIButton

        agreementViewVC.agreementNum = button.tag
        self.present(agreementViewVC, animated: true)
    }

    @objc private func checkboxPressed(_ sender: UIButton!){
        agreementCheckbox2.isSelected = sender.isSelected
        agreementCheckbox3.isSelected = sender.isSelected
        agreementCheckbox4.isSelected = sender.isSelected
    }

    @objc private func agreePressed(_ sender: UIButton!){
        if(!agreementCheckbox2.isSelected || !agreementCheckbox3.isSelected || !agreementCheckbox4.isSelected){
            return
        }

        if(getWallet){
            let nemonicVerificationVC = NemonicVerificationVC()
            nemonicVerificationVC.getWallet = true
            self.navigationController?.pushViewController(nemonicVerificationVC, animated: true)
        }
        else{
            let passwordVC = PasswordVC()
            self.navigationController?.pushViewController(passwordVC, animated: true)
        }
    }

    @objc private func backPressed(_ sender: UIButton){
        self.dismiss(animated: true)
    }


}