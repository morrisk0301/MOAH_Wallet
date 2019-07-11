//
//  ViewController.swift
//  MOAH Wallet
//
//  Created by 김경인 on 2019-06-29.
//  Copyright © 2019 Sejong University Alom. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    let moahWalletText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        textView.text = "MOAH Wallet"
        textView.font = UIFont.boldSystemFont(ofSize: 40)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false

        return textView
    }()

    let newWalletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로운 지갑 만들기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    let getWalletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기존 지갑 복원하기", for: .normal) 
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(moahWalletText)
        view.addSubview(newWalletButton)
        view.addSubview(getWalletButton)

        setupLayout()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        moahWalletText.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        moahWalletText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moahWalletText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moahWalletText.heightAnchor.constraint(equalToConstant: 60).isActive = true

        getWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        getWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        getWalletButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        newWalletButton.heightAnchor.constraint(equalToConstant: 180).isActive = true

        newWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newWalletButton.bottomAnchor.constraint(equalTo: getWalletButton.topAnchor, constant: 30).isActive = true
        newWalletButton.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }

    @objc private func buttonPressed(_ sender: UIButton){
        let agreementVC = AgreementVC()
        if(sender.tag == 2){
            agreementVC.getWallet = true
        }
        let navigationController = UINavigationController(rootViewController: agreementVC)

        self.present(navigationController, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func checkAccount() {
        let account: EthAccount = EthAccount.accountInstance
        if(account.getKeyStoreManager() == nil){
            let lockVC = LockVC()
            self.present(lockVC, animated: false)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
                red: (rgb >> 16) & 0xFF,
                green: (rgb >> 8) & 0xFF,
                blue: rgb & 0xFF
        )
    }
}