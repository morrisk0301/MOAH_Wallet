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

    let passwordText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.text = "MOAH Wallet\n비밀번호를 입력해주세요"
        textView.font = UIFont(name:"NanumSquareRoundEB", size: 20)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()

        let useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        if (useBiometrics) {
            //bioVerification()
        }

        secureKeypad.delegate = self

        view.addSubview(passwordText)
        view.addSubview(pwLine)
        view.addSubview(pwLine2)
        view.addSubview(pwLine3)
        view.addSubview(pwLine4)
        view.addSubview(pwLine5)
        view.addSubview(pwLine6)
        view.addSubview(errorText)
        view.addSubview(secureKeypad)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout() {
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        passwordText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        passwordText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordText.heightAnchor.constraint(equalToConstant: 150).isActive = true

        pwLine.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth/8).isActive = true
        pwLine.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine2.leadingAnchor.constraint(equalTo: pwLine.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine2.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine2.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine3.leadingAnchor.constraint(equalTo: pwLine2.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine3.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine3.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine4.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine4.leadingAnchor.constraint(equalTo: pwLine3.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine4.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine4.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine5.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine5.leadingAnchor.constraint(equalTo: pwLine4.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine5.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine5.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        pwLine6.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -screenHeight/10).isActive = true
        pwLine6.leadingAnchor.constraint(equalTo: pwLine5.trailingAnchor, constant: screenWidth/20).isActive = true
        pwLine6.widthAnchor.constraint(equalToConstant: screenWidth/12).isActive = true
        pwLine6.heightAnchor.constraint(equalToConstant: screenWidth/10).isActive = true

        errorText.topAnchor.constraint(equalTo: pwLine.bottomAnchor, constant: 5).isActive = true
        errorText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorText.heightAnchor.constraint(equalToConstant: 50).isActive = true

        secureKeypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/15).isActive = true
        secureKeypad.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        secureKeypad.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        secureKeypad.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
    }

    func cellPressed(_ cellItem: String) {
        password.append(cellItem)
        changeLabel(password.count)

        if(password.count >= 6){
            if(account.checkPassword(password)){
                let mainVC = MainVC()
                self.appDelegate.window?.rootViewController = mainVC
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
                    let mainVC = MainVC()

                    self.appDelegate.window?.rootViewController = mainVC
                    self.view.window!.rootViewController?.dismiss(animated: true)
                }
            }
        }
    }
}