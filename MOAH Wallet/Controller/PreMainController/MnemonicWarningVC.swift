//
// Created by 김경인 on 2019-07-01.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicWarningVC: UIViewController {

    var tempMnemonic: String?

    let screenSize = UIScreen.main.bounds

    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "비밀 시드 구문"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let mnemonicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        label.text = "비밀 시드 구문으로 지갑을 백업하고\n복원할 수 있습니다."
        label.font = UIFont(name: "NanumSquareRoundR", size: 18)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 120))

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5

        let attrText = NSMutableAttributedString(string: "주의: 비밀 시드 구문을 절대 공개하지 마십시오. 시드 구문으로 사용자의 암호화폐를 탈취할 수 있습니다!",
                attributes: [NSAttributedString.Key.paragraphStyle: style,
                             NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundEB", size: 18)!])

        label.attributedText = attrText
        label.textColor = UIColor(key: "dark")
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.clearNavigationBar()

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(headLabel)
        view.addSubview(mnemonicLabel)
        view.addSubview(warningLabel)
        view.addSubview(nextButton)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenWidth = screenSize.width

        headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        mnemonicLabel.topAnchor.constraint(equalTo: headLabel.bottomAnchor).isActive = true
        mnemonicLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        mnemonicLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        mnemonicLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        warningLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func backPressed(_ sender: UIBarButtonItem) {
        let mainVC = self.navigationController?.viewControllers.first as! MainVC
        mainVC.signUp = false
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func nextPressed(_ sender: UIButton) {
        let mnemonicVC = MnemonicVC()
        mnemonicVC.tempMnemonic = self.tempMnemonic!

        self.navigationController?.pushViewController(mnemonicVC, animated: true)
    }
}
