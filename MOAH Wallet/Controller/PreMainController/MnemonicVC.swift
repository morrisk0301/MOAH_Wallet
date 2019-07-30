//
// Created by 김경인 on 2019-07-07.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicVC: UIViewController {

    var tempMnemonic: String?
    var isCopied = false

    let screenSize = UIScreen.main.bounds

    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "비밀 시드 구문"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let explainLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 300))

        label.text = "다음은 회원님의 비밀 시드 구문입니다.\n\n비밀 시드 구문을 순서대로 입력하여, 지갑 인증을 진행해 주세요."
        label.font = UIFont(name: "NanumSquareRoundR", size: 17, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let mnemonicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 150))

        label.text = "labelTest"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "비밀 시드 구문으로 지갑을 백업하고, 복원할 수 있습니다.\n\n시드 구문을 절대 공개하지 마십시오. 시드 구문을 사용하여 사용자의 암호화폐를 탈취할 수 있습니다.\n\nMOAH Wallet은 사용자의 시드 구문을 수집하지 않으며, 시드 구문은 암호화 되어 안전하게 저장됩니다."
        label.font = UIFont(name: "NanumSquareRoundR", size: 15, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("시드 구문 복사하기", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(headLabel)
        view.addSubview(explainLabel)
        view.addSubview(mnemonicLabel)
        view.addSubview(warningLabel)
        view.addSubview(nextButton)

        let mnemonic: String = tempMnemonic!

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attrText = NSMutableAttributedString(string: mnemonic,
                attributes: [NSAttributedString.Key.paragraphStyle: style,
                             NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 20, dynamic: true), 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
        mnemonicLabel.attributedText = attrText

        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:-screenSize.width/20, y: mnemonicLabel.frame.height+screenSize.height/100, width: mnemonicLabel.frame.width+screenSize.width/10, height: 1)
        mnemonicLabel.layer.addSublayer(border)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.nextButton.setTitle("시드 구문 복사하기", for: .normal) 
        self.isCopied = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        explainLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: screenHeight/50).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        explainLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true

        mnemonicLabel.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: screenHeight/30).isActive = true
        mnemonicLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/10).isActive = true
        mnemonicLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/10).isActive = true
        mnemonicLabel.heightAnchor.constraint(equalToConstant: screenHeight/6).isActive = true

        warningLabel.topAnchor.constraint(equalTo: mnemonicLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/20).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func nextPressed(_ sender: UIButton) {
        if(!isCopied){
            let util = Util()
            UIPasteboard.general.string = self.mnemonicLabel.text
            let alertVC = util.alert(title: "시드 구문 복사", body: "시드 구문이 클립보드에 복사되었습니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
                DispatchQueue.main.async{
                    self.nextButton.setTitle("시드 구문 인증하기", for: .normal)
                    self.isCopied = true
                }
            })
            self.present(alertVC, animated: false)
        }
        else{
            let mnemonicVerificationVc = MnemonicVerificationVC()
            self.navigationController?.pushViewController(mnemonicVerificationVc, animated: true)
        }

    }
}