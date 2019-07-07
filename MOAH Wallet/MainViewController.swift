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
        button.addTarget(self, action: #selector(newWalletButtonPressed(_:)), for: .touchUpInside)

        return button
    }()

    let getWalletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기존 지갑 복원하기", for: .normal) 
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1 = UINavigationController()
        nav1.viewControllers = [self]

        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = nav1

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

    @objc private func newWalletButtonPressed(_ sender: UIButton!){
        let agreementVC = AgreementVC()
        self.navigationController?.pushViewController(agreementVC, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}