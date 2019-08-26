//
// Created by 김경인 on 2019-07-12.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import web3swift

class AlertVC: UIViewController{

    var transferAlertView: TransferAlertView?
    var normalAlertView: NormalAlertView?

    var alertHeight = UIScreen.main.bounds.height/3.8
    var alertWidth = UIScreen.main.bounds.width/1.2
    var alertTitle: String?
    var alertBody: String?
    var alertButtonTitle: String?
    var buttonAction: ((Bool) -> Void)?
    var buttonBool: Bool?
    var buttonNum = 1
    var use: String = "alert"
    var info: TransferInfo?
    var balance: BigUInt?
    var isToken = false

    let screenSize = UIScreen.main.bounds

    let alertView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.isOpaque = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0

        return view
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel".localized, for: .normal)
        button.setTitleColor(UIColor(red: 130, green: 130, blue: 130), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 0
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(key: "regular"), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isOpaque = false

        view.addSubview(alertView)
        alertView.addSubview(nextButton)
        alertView.addSubview(backButton)

        nextButton.setTitle(self.alertButtonTitle!, for: .normal)

        if(use == "transfer"){
            self.alertHeight = screenSize.height/1.8
            transferAlertView = TransferAlertView(info: self.info!, isToken: self.isToken)

            transferAlertView!.titleLabel.text = self.alertTitle!
            transferAlertView!.translatesAutoresizingMaskIntoConstraints = false

            alertView.addSubview(transferAlertView!)

            transferAlertView!.topAnchor.constraint(equalTo: alertView.topAnchor).isActive = true
            transferAlertView!.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
            transferAlertView!.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
            transferAlertView!.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true

            if(self.isToken){
                if(self.info!.gas > self.balance!){
                    transferAlertView?.warningLabel.text = "가스 비용이 부족합니다."
                    transferAlertView?.warningLabel.textColor = UIColor.red
                    nextButton.isEnabled = false
                    nextButton.setTitleColor(UIColor(red: 130, green: 130, blue: 130), for: .normal)
                }
            }else{
                if(self.info!.total > self.balance!){
                    transferAlertView?.warningLabel.text = "가스 비용이 부족합니다."
                    transferAlertView?.warningLabel.textColor = UIColor.red
                    nextButton.isEnabled = false
                    nextButton.setTitleColor(UIColor(red: 130, green: 130, blue: 130), for: .normal)
                }
            }
        }
        else{
            normalAlertView = NormalAlertView()

            normalAlertView!.titleLabel.text = self.alertTitle!
            normalAlertView!.setBodyText(text: self.alertBody!)
            normalAlertView!.translatesAutoresizingMaskIntoConstraints = false

            alertView.addSubview(normalAlertView!)

            normalAlertView!.topAnchor.constraint(equalTo: alertView.topAnchor).isActive = true
            normalAlertView!.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
            normalAlertView!.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
            normalAlertView!.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        }

        setupLayout()
        if(buttonNum > 1){
            setupTwoButton()
        }
        else{
            backButton.isHidden = true
            setupOneButton()
        }
    }

    override func viewDidLayoutSubviews() {
        if(use == "transfer"){
            let border = CALayer()
            border.backgroundColor = UIColor(key: "grey").cgColor
            border.frame = CGRect(x:0, y: -screenSize.height/40, width: alertWidth-(screenSize.width/15)*2, height: 1)
            transferAlertView!.totalTagLabel.layer.addSublayer(border)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.alertView.alpha = 1
        }, completion: nil)
    }

    private func setupLayout(){
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: alertHeight).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: alertWidth).isActive = true
    }

    private func setupOneButton(){
        nextButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: screenSize.height/16.5).isActive = true
    }

    private func setupTwoButton(){
        backButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: alertView.centerXAnchor, constant: -0.5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: screenSize.height/16.5).isActive = true

        nextButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: screenSize.height/16.5).isActive = true
    }

    @objc private func buttonPressed(_ sender: UIButton){
        if(sender.tag == 1){
            buttonAction?(true)
            buttonBool = true
        }
        else{
            buttonAction?(false)
            buttonBool = false
        }
        self.dismiss(animated: false)
    }
}