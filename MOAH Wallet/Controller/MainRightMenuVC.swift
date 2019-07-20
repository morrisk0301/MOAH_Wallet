//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MainRightMenuVC: UIViewController{

    let screenSize = UIScreen.main.bounds

    let welcomeText: UITextView = {

        let textView = UITextView(frame: CGRect(x: 10, y: 100, width: 100, height: 60))

        textView.text = "안녕하세요,\nMOAH Wallet 입니다."
        textView.font = UIFont(name:"NanumSquareRoundB", size: 22)
        textView.textColor = UIColor(key: "darker")
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let walletText: UITextView = {
        let textView = UITextView()

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20

        let attrText = NSMutableAttributedString(string: "계정 관리",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20), 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"), 
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n  네트워크 관리",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))
        attrText.append(NSAttributedString(string: "\n  시드 구문 관리",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))
        attrText.append(NSAttributedString(string: "\n  비밀번호 및 인증 관리",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        textView.attributedText = attrText
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let csText: UITextView = {
        let textView = UITextView()

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20

        let attrText = NSMutableAttributedString(string: "고객센터",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n  공지사항",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))
        attrText.append(NSAttributedString(string: "\n  FAQ",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))
        attrText.append(NSAttributedString(string: "\n  이메일 문의하기",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        textView.attributedText = attrText
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    let infoText: UITextView = {
        let textView = UITextView()

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20

        let attrText = NSMutableAttributedString(string: "정보",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n  약관 및 정책",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))
        attrText.append(NSAttributedString(string: "\n  앱 버전",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 18),
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        textView.attributedText = attrText
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "lighter")
        view.addSubview(welcomeText)
        view.addSubview(walletText)
        view.addSubview(csText)
        view.addSubview(infoText)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        welcomeText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight/20).isActive = true
        welcomeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/5).isActive = true
        welcomeText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        welcomeText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        walletText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: screenHeight/30).isActive = true
        walletText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/4).isActive = true
        walletText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        walletText.heightAnchor.constraint(equalToConstant: screenHeight/5).isActive = true

        csText.topAnchor.constraint(equalTo: walletText.bottomAnchor, constant: screenHeight/30).isActive = true
        csText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/4).isActive = true
        csText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        csText.heightAnchor.constraint(equalToConstant: screenHeight/5).isActive = true

        infoText.topAnchor.constraint(equalTo: csText.bottomAnchor, constant: screenHeight/30).isActive = true
        infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/4).isActive = true
        infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: screenHeight/5).isActive = true
    }
}