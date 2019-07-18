//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class WalletDoneVC: UIViewController{

    var getWallet = false

    let screenSize = UIScreen.main.bounds
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    let doneText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 150))
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false

        return textView
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.setupBackground()

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        if(getWallet){
            let attrText = NSMutableAttributedString(string: "지갑 복원이 완료되었습니다!",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 22)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white])
            attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을\n사용할 수 있습니다.",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16)!, 
                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
            doneText.attributedText = attrText
        }
        else{
            let attrText = NSMutableAttributedString(string: "지갑 생성이 완료되었습니다!",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 22)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white])
            attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을\n사용할 수 있습니다.",
                    attributes: [NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.white]))
            doneText.attributedText = attrText
        }


        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(doneText)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        let screenWidth = screenSize.width

        doneText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        doneText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        doneText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        doneText.heightAnchor.constraint(equalToConstant: 200).isActive = true

        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/20).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func backPressed(_ sender: UIButton){
        let mainContainerVC = MainContainerVC()
        self.appDelegate.window?.rootViewController = mainContainerVC
    }
}