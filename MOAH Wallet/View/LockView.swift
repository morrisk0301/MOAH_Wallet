//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class LockView: UIView {

    let screenSize = UIScreen.main.bounds
    var password:String = ""

    let passwordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.text = "MOAH Wallet\n비밀번호를 입력해주세요"
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0

        return label
    }()

    let errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.text = ""
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let pwLine: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let pwLine2: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let pwLine3: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let pwLine4: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let pwLine5: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let pwLine6: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "pwLine"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let animation: CABasicAnimation = {
        let midX = UIScreen.main.bounds.midX
        let midY = UIScreen.main.bounds.midY
        let animation = CABasicAnimation(keyPath: "position")

        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)

        return animation
    }()

    let secureKeypad: KeypadView = {
        let view = KeypadView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupBackground()

        addSubview(passwordLabel)
        addSubview(pwLine)
        addSubview(pwLine2)
        addSubview(pwLine3)
        addSubview(pwLine4)
        addSubview(pwLine5)
        addSubview(pwLine6)
        addSubview(errorLabel)
        addSubview(secureKeypad)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBackground(){
        let backgroundImage = UIImageView(image: UIImage(named: "background"))

        addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        passwordLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: screenHeight/10).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        pwLine.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenWidth/8).isActive = true
        pwLine.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine2.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine2.leadingAnchor.constraint(equalTo: pwLine.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine2.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine2.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine3.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine3.leadingAnchor.constraint(equalTo: pwLine2.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine3.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine3.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine4.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine4.leadingAnchor.constraint(equalTo: pwLine3.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine4.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine4.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine5.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine5.leadingAnchor.constraint(equalTo: pwLine4.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine5.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine5.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine6.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine6.leadingAnchor.constraint(equalTo: pwLine5.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine6.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine6.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        errorLabel.topAnchor.constraint(equalTo: pwLine.bottomAnchor, constant: 5).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        secureKeypad.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -screenHeight/15).isActive = true
        secureKeypad.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        secureKeypad.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        secureKeypad.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
    }

    func changeLabel(_ offset: Int){
        let changeImage = UIImage(named: "pwLabel")
        switch offset{
        case 6:
            pwLine6.image = changeImage
        case 5:
            pwLine5.image = changeImage
        case 4:
            pwLine4.image = changeImage
        case 3:
            pwLine3.image = changeImage
        case 2:
            pwLine2.image = changeImage
        case 1:
            pwLine.image = changeImage
        default:
            return
        }
    }

    func deleteLabel(_ offset: Int){
        let changeImage = UIImage(named: "pwLine")
        switch offset{
        case 1:
            pwLine.image = changeImage
        case 2:
            pwLine2.image = changeImage
        case 3:
            pwLine3.image = changeImage
        case 4:
            pwLine4.image = changeImage
        case 5:
            pwLine5.image = changeImage
        case 6:
            pwLine6.image = changeImage
        default:
            return
        }
    }
}