//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Security
import LocalAuthentication

class PasswordVC: UIViewController, UITextFieldDelegate, KeypadViewDelegate{

    var getWallet: Bool = false
    var useBiometrics: Bool = false
    var password: String?
    var passwordTemp: String = ""
    var salt: String?
    var confirm = false

    let autoContext = LAContext()
    let util = Util()
    let account: EthAccount = EthAccount.accountInstance
    let defaults = UserDefaults.standard
    let screenSize = UIScreen.main.bounds

    let passwordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.font = UIFont(name:"NanumSquareRoundB", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear

        return label
    }()

    let errorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        label.text = ""
        label.font = UIFont(name:"NanumSquareRoundB", size: 14)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
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

    let secureKeypad: KeypadView = {
        let view = KeypadView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.replaceBackButton(color: "light")
        self.clearNavigationBar()

        view.addSubview(passwordLabel)
        view.addSubview(pwLine)
        view.addSubview(pwLine2)
        view.addSubview(pwLine3)
        view.addSubview(pwLine4)
        view.addSubview(pwLine5)
        view.addSubview(pwLine6)
        view.addSubview(errorLabel)
        view.addSubview(secureKeypad)

        secureKeypad.delegate = self

        if(!confirm){
            passwordLabel.text = "MOAH Wallet 잠금\n비밀번호를 설정해주세요."
        }
        else{
            passwordLabel.text = "비밀번호를 한번 더 입력해주세요."
        }

        setupLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let changeImage = UIImage(named: "pwLine")

        errorLabel.text = ""
        passwordTemp = ""

        pwLine6.image = changeImage
        pwLine5.image = changeImage
        pwLine4.image = changeImage
        pwLine3.image = changeImage
        pwLine2.image = changeImage
        pwLine.image = changeImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    private func setupLayout(){
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width

        passwordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true

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

        errorLabel.topAnchor.constraint(equalTo: pwLine.bottomAnchor, constant: 5).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        secureKeypad.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenHeight/10).isActive = true
        secureKeypad.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        secureKeypad.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        secureKeypad.heightAnchor.constraint(equalToConstant: screenHeight/3).isActive = true
    }

    func cellPressed(_ cellItem: String) {
        passwordTemp.append(cellItem)
        changeLabel(passwordTemp.count)

        if(passwordTemp.count >= 6){
            if(!confirm){
                let passwordVC = PasswordVC()
                passwordVC.confirm = true

                if(getWallet){
                    passwordVC.getWallet = true
                }
                passwordVC.password = passwordTemp

                self.navigationController?.pushViewController(passwordVC, animated: true)
            }
            else if(confirm && password == passwordTemp){
                account.savePassword(password!)
                authBiometrics()
            }
            else if(confirm && password != passwordTemp){
                passwordTemp = ""
                let changeImage = UIImage(named: "pwLine")


                self.view.layer.add(animation, forKey: "position")

                errorLabel.text = "비밀번호가 일치하지 않습니다."
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
        if(passwordTemp.count > 0){
            deleteLabel(passwordTemp.count)
            passwordTemp.removeLast()
        }
    }

    private func authBiometrics(){
        if(autoContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)){
            let alertVC = util.alert(title: "생채 인식 기능 사용", body: "빠른 앱 실행을 위해\n생채 인식 기능을 사용하시겠습니까?", buttonTitle: "사용하기"){(next) in
                if(next){
                    self.autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생채 인식"){(success, error) in
                        DispatchQueue.main.async {
                            if (success) {
                                self.useBiometrics = true
                            }
                            self.proceedView()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.proceedView()
                    }
                }
            }
            self.present(alertVC, animated: false)
        }else{
            DispatchQueue.main.async {
                self.proceedView()
            }
        }
    }

    private func proceedView(){
        self.defaults.set(self.useBiometrics, forKey: "useBiometrics")

        if(self.getWallet){
            let walletDoneVC = WalletDoneVC()

            if(self.account.setAccount()){
                walletDoneVC.getWallet = true
                self.present(walletDoneVC, animated: true)
            }
        }
        else{
            let mnemonic = self.account.generateMnemonic()

            let mainContainerVC = MainContainerVC()
            mainContainerVC.signUp = true
            mainContainerVC.tempMnemonic = mnemonic

            if(self.account.setAccount()){
                let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

                appDelegate.window?.rootViewController = mainContainerVC
            }
        }
    }
}