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

    let agreementText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 60))
        textView.text = "MOAH Wallet \n서비스 약관에 동의해주세요."
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    let agreementCheckbox: CheckBox = {
        let checkbox = CheckBox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(checkboxPressed(_:)), for: .touchUpInside)

        return checkbox
    }()

    let checkboxText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 30))
        textView.text = "MOAH Wallet 이용약관 전체 동의"
        textView.font = UIFont(name:"NanumSquareRoundB", size: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false

        return textView
    }()

    let agreementScroll: UIScrollView = {
        let scrollView = UIScrollView()


        /*
        agreementView.translatesAutoresizingMaskIntoConstraints = false
        agreementView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        agreementView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        agreementView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        agreementView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        */


        scrollView.layer.borderColor = UIColor(rgb: 0x0067E2).cgColor
        scrollView.layer.borderWidth = 1.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20)
        button.backgroundColor = UIColor(rgb: 0x9FC8FF)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(agreePressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton()

        view.backgroundColor = .white

        view.addSubview(agreementText)
        view.addSubview(agreementScroll)
        view.addSubview(agreementCheckbox)
        view.addSubview(checkboxText)
        view.addSubview(nextButton)

        setupLayout()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewDidLayoutSubviews() {
        let agreementView = UITextView(frame: CGRect(x: 10, y: 10, width: agreementScroll.frame.width*(0.95), height: agreementScroll.frame.height))
        agreementView.text = agreement
        agreementView.isEditable = false
        agreementView.font = UIFont(name:"NanumSquareRoundB", size: 12)

        agreementScroll.addSubview(agreementView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        agreementText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        agreementText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        agreementText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        agreementText.heightAnchor.constraint(equalToConstant: 60).isActive = true

        agreementScroll.topAnchor.constraint(equalTo: agreementText.bottomAnchor, constant: 20).isActive = true
        agreementScroll.bottomAnchor.constraint(equalTo: agreementCheckbox.topAnchor, constant: -30).isActive = true
        agreementScroll.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        agreementScroll.widthAnchor.constraint(equalToConstant: screenWidth*(0.9)).isActive = true

        agreementCheckbox.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        agreementCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        agreementCheckbox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        agreementCheckbox.heightAnchor.constraint(equalToConstant: 30).isActive = true

        checkboxText.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -21).isActive = true
        checkboxText.leadingAnchor.constraint(equalTo: agreementCheckbox.trailingAnchor, constant: 10).isActive = true
        checkboxText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        checkboxText.heightAnchor.constraint(equalToConstant: 30).isActive = true

        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func checkboxPressed(_ sender: CheckBox){
        if(!checked){
            checked = true
            nextButton.backgroundColor = UIColor(rgb: 0x0067E2)
        }else{
            checked = false
            nextButton.backgroundColor = UIColor(rgb: 0x9FC8FF)
        }
    }

    @objc private func agreementPressed(_ sender: UIButton!){
        let agreementViewVC = AgreementViewVC()
        let button = sender as UIButton

        agreementViewVC.agreementNum = button.tag
        self.present(agreementViewVC, animated: true)
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