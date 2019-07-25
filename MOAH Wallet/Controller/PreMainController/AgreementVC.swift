//
// Created by 김경인 on 2019-07-04.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AgreementVC: UIViewController {

    var getWallet = false
    var checked = false

    let screenSize = UIScreen.main.bounds
    let agreement: String = "이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. 이용약관 입니다. "

    let agreementLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 60))
        label.text = "MOAH Wallet \n서비스 약관에 동의해주세요."
        label.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        label.numberOfLines = 0
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    let agreementCheckbox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(checkboxPressed(_:)), for: .touchUpInside)

        return checkbox
    }()

    let checkboxLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        label.text = "MOAH Wallet 이용약관 전체 동의"
        label.font = UIFont(name:"NanumSquareRoundB", size: 15, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(key: "darker")
        label.textAlignment = .left

        return label
    }()

    let agreementScroll: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.layer.borderColor = UIColor(key: "darker").cgColor
        scrollView.layer.borderWidth = 1.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.backgroundColor = UIColor(key: "light")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(agreePressed(_:)), for: .touchUpInside)
        button.isEnabled = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.clearNavigationBar()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(agreementLabel)
        view.addSubview(agreementScroll)
        view.addSubview(agreementCheckbox)
        view.addSubview(checkboxLabel)
        view.addSubview(nextButton)

        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        let agreementView = UITextView(frame: CGRect(x: 10, y: 10, width: agreementScroll.frame.width*(0.95), height: agreementScroll.frame.height))
        agreementView.text = agreement
        agreementView.isEditable = false
        agreementView.font = UIFont(name:"NanumSquareRoundR", size: 12, dynamic: true)
        agreementView.textColor = UIColor(key: "darker")

        agreementScroll.addSubview(agreementView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        agreementLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        agreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        agreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        agreementScroll.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 20).isActive = true
        agreementScroll.bottomAnchor.constraint(equalTo: agreementCheckbox.topAnchor, constant: -30).isActive = true
        agreementScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        agreementScroll.widthAnchor.constraint(equalToConstant: screenWidth*(0.9)).isActive = true

        agreementCheckbox.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        agreementCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        agreementCheckbox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxLabel.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -21).isActive = true
        checkboxLabel.leadingAnchor.constraint(equalTo: agreementCheckbox.trailingAnchor, constant: 10).isActive = true
        checkboxLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        checkboxLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func checkboxPressed(_ sender: CheckBox){
        if(!checked){
            checked = true
            nextButton.backgroundColor = UIColor(key: "regular")
            nextButton.isEnabled = true
        }else{
            checked = false
            nextButton.backgroundColor = UIColor(key: "light")
            nextButton.isEnabled = false
        }
    }

    @objc private func agreePressed(_ sender: UIButton!){
        if(getWallet){
            let mnemonicVerificationGetVC = MnemonicVerificationGetVC()
            self.navigationController?.pushViewController(mnemonicVerificationGetVC, animated: true)
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