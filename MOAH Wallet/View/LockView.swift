//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class LockView: UIView, KeypadViewDelegate {

    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.text = "MOAH Wallet\n비밀번호를 입력해주세요"
        textView.font = UIFont(name:"NanumSquareRoundB", size: 20)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.backgroundColor = .clear

        return textView
    }()

    let errorText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.text = ""
        textView.font = UIFont(name:"NanumSquareRoundB", size: 14)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
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

        addSubview(passwordText)
        addSubview(pwLine)
        addSubview(pwLine2)
        addSubview(pwLine3)
        addSubview(pwLine4)
        addSubview(pwLine5)
        addSubview(pwLine6)
        addSubview(errorText)
        addSubview(secureKeypad)

        secureKeypad.delegate = self

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout(){
        let screenHeight = frame.height
        let screenWidth = frame.width

        passwordText.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        passwordText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 150).isActive = true

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

        errorText.topAnchor.constraint(equalTo: pwLine.bottomAnchor, constant: 5).isActive = true
        errorText.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorText.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        secureKeypad.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -screenHeight/15).isActive = true
        secureKeypad.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        secureKeypad.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        secureKeypad.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
    }

    func cellPressed(_ cellItem: String) {

    }

    func delPressed() {

    }
}
/*
//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class LockVC: UIViewController, KeypadViewDelegate {

    var password:String = ""

    let screenSize = UIScreen.main.bounds

    let userDefaults = UserDefaults.standard
    let account: EthAccount = EthAccount.accountInstance
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!





    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()

        let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        if (useBiometrics) {
            bioVerification()
        }





        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {

    }

    func cellPressed(_ cellItem: String) {
        password.append(cellItem)
        changeLabel(password.count)

        if(password.count >= 6){
            if(account.checkPassword(password)){
                let mainContainerVC = MainContainerVC()
                self.appDelegate.window?.rootViewController = mainContainerVC
            }
            else{
                password = ""
                let changeImage = UIImage(named: "pwLine")
                self.view.layer.add(animation, forKey: "position")

                errorText.text = "비밀번호가 일치하지 않습니다.\n5회 오류시 지갑이 초기화됩니다."
                pwLine6.image = changeImage
                pwLine5.image = changeImage
                pwLine4.image = changeImage
                pwLine3.image = changeImage
                pwLine2.image = changeImage
                pwLine.image = changeImage
            }
        }

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

    func delPressed() {
        if(password.count > 0){
            deleteLabel(password.count)
            password.removeLast()
        }
    }

    private func bioVerification() {
        let autoContext = LAContext()
        autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생채 인식") { (success, error) in
            DispatchQueue.main.async {
                if (success) {
                    self.account.bioProceed()
                    let mainContainerVC = MainContainerVC()
                    self.appDelegate.window?.rootViewController = mainContainerVC
                }
            }
        }
    }
}
*/