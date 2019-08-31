//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class WalletDoneVC: UIViewController{

    var getWallet = false
    var isTransfer = false

    let screenSize = UIScreen.main.bounds
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    let doneLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 150))

        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Main Menu".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 2
        button.addTarget(self, action: #selector(backClicked(_:)), for: .touchUpInside)

        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.setupBackground()

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        if(isTransfer){
            let attrText = NSMutableAttributedString(string: "Your transaction has been started!".localized,
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white])
            attrText.append(NSAttributedString(string: "\n\n\n\n" + "You can check your TX status in TX History Tab.".localized,
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]))
            doneLabel.attributedText = attrText
        }
        else {
            if (getWallet) {
                let attrText = NSMutableAttributedString(string: "Your wallet has been restored!".localized,
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white])
                attrText.append(NSAttributedString(string: "\n\n\n\n" + "You can now access your Ethereum wallet.".localized,
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                     NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]))
                doneLabel.attributedText = attrText
            } else {
                let attrText = NSMutableAttributedString(string: "Your wallet has been created!".localized,
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white])
                attrText.append(NSAttributedString(string: "\n\n\n\n" + "You can now access your Ethereum wallet.".localized,
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                     NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)]))
                doneLabel.attributedText = attrText
            }
        }


        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(doneLabel)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        doneLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        doneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        doneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        doneLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true

        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
    }

    @objc private func backClicked(_ sender: UIButton){
        if(isTransfer){
            let rootViewController = self.view.window?.rootViewController as! MainContainerVC
            rootViewController.isReload = true
            self.view.window?.rootViewController?.dismiss(animated: true)

            return
        }

        let mainContainerVC = MainContainerVC()
        self.appDelegate.window?.rootViewController = mainContainerVC
    }
}