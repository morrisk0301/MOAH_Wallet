//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class PrivateKeyVC: UIViewController {

    let account: EthAccount = EthAccount.shared
    let screenSize = UIScreen.main.bounds

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 300))

        label.text = "Following text is your private key.".localized
        label.font = UIFont(name: "NanumSquareRoundR", size: 17, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let privateKeyLabel: UILabel = {
        let label = UILabel()


        label.text = ""
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "Anyone can access your wallet through private key. Be careful not to disclose it.\n\nMOAH Wallet does not collect users' private key. Your private key will be securely stored in to your device after being encrypted.".localized
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let copyButton: CustomButton = {
        let button = CustomButton()

        button.setTitle("Copy Private Key".localized, for: .normal)
        button.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(copyPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "View Private Key".localized)
        self.transparentNavigationBar()

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(explainLabel)
        view.addSubview(privateKeyLabel)
        view.addSubview(warningLabel)
        view.addSubview(copyButton)

        privateKeyLabel.text = account.getPrivateKey()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:-screenSize.width/20, y: privateKeyLabel.frame.height+screenSize.height/100, width: privateKeyLabel.frame.width+screenSize.width/10, height: 1)
        privateKeyLabel.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        explainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/20).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        privateKeyLabel.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenSize.height/15).isActive = true
        privateKeyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/10).isActive = true
        privateKeyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/10).isActive = true
        privateKeyLabel.heightAnchor.constraint(equalToConstant: screenSize.height/10).isActive = true

        warningLabel.topAnchor.constraint(equalTo: privateKeyLabel.bottomAnchor, constant: screenSize.height/15).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true

        copyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
        copyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        copyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        copyButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
    }

    @objc func copyPressed(_ sender: UIButton){
        let util = Util()
        UIPasteboard.general.string = self.privateKeyLabel.text

        let alertVC = util.alert(title: "Copy Private Key".localized, body: "Private key has been copied to clipboard.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in
        })
        self.present(alertVC, animated: false)
    }
}
