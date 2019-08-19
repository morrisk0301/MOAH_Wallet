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
        button.setTitle("메인 화면", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.tag = 2
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)

        return button
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.setupBackground()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        if(isTransfer){
            let attrText = NSMutableAttributedString(string: "토큰 전송이 시작되었습니다!",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white])
            attrText.append(NSAttributedString(string: "\n\n\n거래내역 탭에서 전송 내역을\n조회할 수 있습니다.",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
            doneLabel.attributedText = attrText
        }
        else {
            if (getWallet) {
                let attrText = NSMutableAttributedString(string: "지갑 복원이 완료되었습니다!",
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white])
                attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을\n사용할 수 있습니다.",
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white]))
                doneLabel.attributedText = attrText
            } else {
                let attrText = NSMutableAttributedString(string: "지갑 생성이 완료되었습니다!",
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 22)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white])
                attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을\n사용할 수 있습니다.",
                        attributes: [NSAttributedString.Key.paragraphStyle: style,
                                     NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16)!,
                                     NSAttributedString.Key.foregroundColor: UIColor.white]))
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
        doneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/10).isActive = true
        doneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/10).isActive = true
        doneLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true

        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
    }

    @objc private func backPressed(_ sender: UIButton){
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