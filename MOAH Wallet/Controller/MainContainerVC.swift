//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MainContainerVC: UIViewController, MainControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate{

    var isExpandLeft = false
    var isExpandRight = false
    var signUp = false
    var tempMnemonic: String?
    var symbol = "ETH"
    var mainLeftMenuVC: MainLeftMenuVC!
    var mainRightMenuVC: MainRightMenuVC!
    var tokenSelectVC: TokenSelectVC!
    var centerController: UIViewController!
    var mainVC: MainVC!
    var transparentView = UIView()
    var style:UIStatusBarStyle = .default

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.style = .lightContent

        mainVC = MainVC()
        mainVC.signUp = self.signUp
        mainVC.tempMnemonic = self.tempMnemonic
        mainVC.delegate = self
        mainVC.tokenView.delegate = self
        centerController = UINavigationController(rootViewController: mainVC)

        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)

        initVCs()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.style = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func animatePanel(shouldExpand: Bool, side: String?, menuOption: Any?) {
        if shouldExpand {
            if(side == "left"){
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                        options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
                    self.transparentView.alpha = 0.3
                    self.centerController.view.frame.origin.x = self.centerController.view.frame.width - self.screenSize.width/5
                    self.style = .default
                    self.setNeedsStatusBarAppearanceUpdate()
                }, completion: nil)
            }
            else if(side == "right"){
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                        options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
                    self.transparentView.alpha = 0.3
                    self.centerController.view.frame.origin.x = -(self.centerController.view.frame.width - self.screenSize.width/5)
                    self.style = .default
                    self.setNeedsStatusBarAppearanceUpdate()
                }, completion: nil)
            }
            else if(side == "down"){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                        options: .curveEaseInOut, animations: {
                    self.transparentView.alpha = 0.3
                    self.tokenSelectVC.view.frame = CGRect(x: 0, y: self.screenSize.height/2, width: self.screenSize.width, height: self.screenSize.height/2)
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                    options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
                self.transparentView.alpha = 0
                self.centerController.view.frame.origin.x = 0
                self.style = .lightContent
                self.setNeedsStatusBarAppearanceUpdate()
            }, completion: {_ in
                self.transparentView.removeFromSuperview()
            })
        }
    }

    func initVCs(){
        DispatchQueue.main.async{
            self.mainRightMenuVC = MainRightMenuVC()
            self.mainRightMenuVC.delegate = self
            self.view.insertSubview(self.mainRightMenuVC.view, at: 0)
            self.addChild(self.mainRightMenuVC)
            self.mainRightMenuVC.didMove(toParent: self)

            self.mainLeftMenuVC = MainLeftMenuVC()
            self.mainLeftMenuVC.delegate = self
            self.view.insertSubview(self.mainLeftMenuVC.view, at: 0)
            self.addChild(self.mainLeftMenuVC)
            self.mainLeftMenuVC.didMove(toParent: self)
        }
    }

    func proceedToView(side: String, menuOption: Any?){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.centerController.view.frame.origin.x = 0
        }, completion: nil)

        if(side == "left"){
            guard let menuOption = menuOption as? LeftMenuOption else { return }
            self.didSelectLeftMenuOption(menuOption: menuOption)
        }else{
            guard let menuOption = menuOption as? RightMenuOption else { return }
            self.didSelectRightMenuOption(menuOption: menuOption)
        }
    }

    func didSelectRightMenuOption(menuOption: RightMenuOption) {

        switch menuOption {
        case .Welcome:
            self.style = .lightContent
            self.setNeedsStatusBarAppearanceUpdate()
            break
        case .WalletNetwork:
            let controller = NetworkSettingVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .WalletMnemonic:
            let controller = MnemonicSettingVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .WalletPassword:
            let controller = PasswordCheckVC()
            controller.toView = "password"
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSAnnouncement:
            let controller = AnnouncementVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSFAQ:
            let controller = FAQVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSAgreement:
            let controller = AgreementCheckVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSEmail:
            self.sendEmail()
        }
    }

    func didSelectLeftMenuOption(menuOption: LeftMenuOption) {
        switch menuOption {
            case .AccountName:
                self.style = .lightContent
                self.setNeedsStatusBarAppearanceUpdate()
                break
            case .MyAccount:
                let controller = MyAccountVC()
                controller.symbol = self.symbol
                controller.modalPresentationStyle = .overCurrentContext
                present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            case .PrivateKey:
                let controller = PasswordCheckVC()
                controller.toView = "privateKey"
                present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
            case .TxFee:
                let controller = TXFeeVC()
                present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }
    }

    func leftSideMenuClicked(forMenuOption menuOption: LeftMenuOption?) {
        addTransparentView(side: "left")

        view.insertSubview(mainLeftMenuVC.view, aboveSubview: mainRightMenuVC.view)
        isExpandLeft = !isExpandLeft
        if(menuOption == nil){
            animatePanel(shouldExpand: isExpandLeft, side: "left", menuOption: menuOption)
        }
        else{
            proceedToView(side: "left", menuOption: menuOption)
        }
    }

    func rightSideMenuClicked(forMenuOption menuOption: RightMenuOption?) {
        addTransparentView(side: "right")

        view.insertSubview(mainRightMenuVC.view, aboveSubview: mainLeftMenuVC.view)
        isExpandRight = !isExpandRight
        if(menuOption == nil){
            animatePanel(shouldExpand: isExpandRight, side: "right", menuOption: menuOption)
        }
        else{
            proceedToView(side: "right", menuOption: menuOption)
        }
    }

    func tokenViewClicked() {
        addTransparentView(side: "down")

        if(tokenSelectVC == nil){
            tokenSelectVC = TokenSelectVC()

            tokenSelectVC.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height/2)
            view.addSubview(tokenSelectVC.view)
            addChild(tokenSelectVC)
            tokenSelectVC.didMove(toParent: self)
        }else{
            view.addSubview(tokenSelectVC.view)
        }

        animatePanel(shouldExpand: true, side: "down", menuOption: nil)
    }

    func addTransparentView(side: String){
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = centerController.view.frame
        transparentView.alpha = 0
        centerController.view.addSubview(transparentView)

        if(side=="down"){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(transparentViewClicked(_:)))
            transparentView.addGestureRecognizer(tapGesture)
        }else{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewClicked(_:)))
            transparentView.addGestureRecognizer(tapGesture)
        }
    }

    func getBalance() {
        self.showSpinner()
        checkChainNetwork()
        web3.getBalance(address: nil, completion: {(balance) in
            DispatchQueue.main.async {
                let util = Util()
                let balanceTrimmed = util.trimBalance(balance: balance)
                self.mainVC.balanceLabel.text = balanceTrimmed + " " + self.symbol
                self.mainVC.balance = balanceTrimmed
                self.hideSpinner()
            }
        })
    }

    func checkChainNetwork(){
        if(web3.getWeb3Ins() == nil){
            self.hideSpinner()
            let util = Util()
            let alertVC = util.alert(title: "블록체인 네트워크 오류", body: "네트워크에 연결할 수 없습니다.\n네트워크를 재설정해주세요.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
                let controller = NetworkSettingVC()
                let transition = LeftTransition()

                DispatchQueue.main.async{
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
                }
            })
            self.present(alertVC, animated: false)
        }
    }

    func isSignUp() {
        let mnemonicVC = MnemonicVC()
        mnemonicVC.tempMnemonic = self.tempMnemonic!
        self.present(UINavigationController(rootViewController: mnemonicVC), animated: false)
    }

    func txFeeClicked() {
        isExpandLeft = false
        let menuOption = LeftMenuOption(rawValue: 3)
        proceedToView(side: "left", menuOption: menuOption)
        self.transparentView.removeFromSuperview()
    }

    @objc private func mainViewClicked(_ sender: UIGestureRecognizer) {
        isExpandRight = false
        isExpandLeft = false
        animatePanel(shouldExpand: false, side: nil, menuOption: nil)
    }

    @objc private func transparentViewClicked(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tokenSelectVC.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.screenSize.height/2)
        }, completion: {_ in
            self.transparentView.removeFromSuperview()
            self.tokenSelectVC.removeFromParent()
        })
    }

    func sendEmail(){
        if(MFMailComposeViewController.canSendMail()){
            let emailTitle = ""
            let messageBody = "문의하기: "
            let toRecipents = ["moahWallet_official@naver.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            present(mc, animated: true, completion: nil)
        }
        else{
            return
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }
}