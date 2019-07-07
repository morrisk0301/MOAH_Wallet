//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class WalletDoneVC: UIViewController{
    var getWallet = false

    let doneText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 150))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false

        return textView
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("뒤로가기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        if(getWallet){
            let attrText = NSMutableAttributedString(string: "지갑 복원이 완료되었습니다!",
                    attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
            attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을 사용할 수 있습니다.",
                    attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
            doneText.attributedText = attrText
        }
        else{
            let attrText = NSMutableAttributedString(string: "지갑 생성이 완료되었습니다!",
                    attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)])
            attrText.append(NSAttributedString(string: "\n\n\n지금부터 MOAH Wallet의 모든 기능을 사용할 수 있습니다.",
                    attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]))
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
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        doneText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        doneText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        doneText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneText.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    @objc private func backPressed(_ sender: UIButton){
        if(getWallet){
            let mainVC = MainVC()
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelegate.window?.rootViewController = mainVC

            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            let mainVC = self.view.window!.rootViewController as? MainVC
            mainVC?.signup = false
            self.view.window!.rootViewController?.dismiss(animated: false)
        }
    }
}