//
//  ViewController.swift
//  MOAH Wallet
//
//  Created by 김경인 on 2019-06-29.
//  Copyright © 2019 Sejong University Alom. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    let screenSize = UIScreen.main.bounds

    let moahWalletLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        label.text = "MOAH Wallet"
        label.font = UIFont(name: "NanumSquareRoundEB", size: 40, dynamic: true)
        label.textColor = .white
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        label.text = "MOAH Wallet은 이더리움 및 ERC20 토큰과\ndApp을 위한 암호화폐 지갑입니다."
        label.font = UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)
        label.backgroundColor = .clear
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }()

    lazy var newWalletButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("새로운 지갑 만들기", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 20, dynamic: true)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    lazy var getWalletButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("기존 지갑 복원하기", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 20, dynamic: true)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()

        view.addSubview(moahWalletLabel)
        view.addSubview(explainLabel)
        view.addSubview(newWalletButton)
        view.addSubview(getWalletButton)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        moahWalletLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight/4).isActive = true
        moahWalletLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moahWalletLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moahWalletLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        explainLabel.topAnchor.constraint(equalTo: moahWalletLabel.bottomAnchor, constant: screenHeight/30).isActive = true
        explainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        explainLabel.widthAnchor.constraint(equalToConstant: screenWidth*(0.85)).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        newWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        newWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        newWalletButton.bottomAnchor.constraint(equalTo: getWalletButton.topAnchor, constant: -20).isActive = true
        newWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        getWalletButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        getWalletButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        getWalletButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        getWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
