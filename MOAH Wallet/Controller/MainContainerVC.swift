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
    var mainLeftMenuVC: MainLeftMenuVC!
    var mainRightMenuVC: MainRightMenuVC!
    var tokenSelectVC: TokenSelectVC!
    var centerController: UIViewController!
    var transparentView = UIView()

    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = MainVC()
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
                }, completion: nil)
            }
            else if(side == "right"){
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                        options: [.curveEaseInOut, UIView.AnimationOptions.allowUserInteraction], animations: {
                    self.transparentView.alpha = 0.3
                    self.centerController.view.frame.origin.x = -(self.centerController.view.frame.width - self.screenSize.width/5)
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
        let transition = LeftTransition()

        switch menuOption {
        case .WalletNetwork:
            let controller = NetworkSettingVC()
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .WalletMnemonic:
            let controller = PasswordCheckVC()
            controller.toView = "mnemonic"
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .WalletPassword:
            let controller = PasswordCheckVC()
            controller.toView = "password"
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .CSAnnouncement:
            let controller = AnnouncementVC()
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .CSFAQ:
            let controller = FAQVC()
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .CSAgreement:
            let controller = AgreementCheckVC()
            view.window!.layer.add(transition, forKey: kCATransition)
            present(UINavigationController(rootViewController: controller), animated: false, completion: nil)
        case .CSEmail:
            self.sendEmail()
        default:
            break
        }
    }

    func didSelectLeftMenuOption(menuOption: LeftMenuOption) {
        switch menuOption {
        case .MyAccount:
            let controller = MyAccountVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .PrivateKey:
            let controller = PasswordCheckVC()
            controller.toView = "privateKey"
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        default:
            break
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