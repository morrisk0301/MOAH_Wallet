//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class MainContainerVC: UIViewController, MainControllerDelegate, MFMailComposeViewControllerDelegate{

    var isExpandLeft = false
    var isExpandRight = false
    var signUp = false
    var tempMnemonic: String?
    var mainLeftMenuVC: MainLeftMenuVC!
    var mainRightMenuVC: MainRightMenuVC!
    var centerController: UIViewController!

    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = MainVC()
        mainVC.signUp = self.signUp
        mainVC.tempMnemonic = self.tempMnemonic
        mainVC.delegate = self
        centerController = UINavigationController(rootViewController: mainVC)

        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func animatePanel(shouldExpand: Bool, side: String?, menuOption: Any?) {
        if shouldExpand {
            if(side == "left"){
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.centerController.view.frame.origin.x = self.centerController.view.frame.width - self.screenSize.width/5
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.centerController.view.frame.origin.x = -(self.centerController.view.frame.width - self.screenSize.width/5)
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }

    func proceedToView(side: String, menuOption: Any?){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerController.view.frame.origin.x = 0
        }, completion: nil)

        if(side == "left"){

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

    func didSelectLeftMenuOption(menuOption: RightMenuOption) {

    }

    func leftSideMenuClicked() {
        if(mainLeftMenuVC == nil){
            mainLeftMenuVC = MainLeftMenuVC()
            if(mainRightMenuVC != nil){
                view.insertSubview(mainLeftMenuVC.view, aboveSubview: mainRightMenuVC.view)
            }else{
                view.insertSubview(mainLeftMenuVC.view, at: 0)
            }
            addChild(mainLeftMenuVC)
            mainLeftMenuVC.didMove(toParent: self)
        }
        else if(mainRightMenuVC != nil){
            view.insertSubview(mainLeftMenuVC.view, aboveSubview: mainRightMenuVC.view)
        }

        isExpandLeft = !isExpandLeft
        animatePanel(shouldExpand: isExpandLeft, side: "left", menuOption: nil)
    }

    func rightSideMenuClicked(forMenuOption menuOption: RightMenuOption?) {
        if(mainRightMenuVC == nil){
            mainRightMenuVC = MainRightMenuVC()
            mainRightMenuVC.delegte = self
            if(mainLeftMenuVC != nil){
                view.insertSubview(mainRightMenuVC.view, aboveSubview: mainLeftMenuVC.view)
            }else{
                view.insertSubview(mainRightMenuVC.view, at: 0)
            }
            addChild(mainRightMenuVC)
            mainRightMenuVC.didMove(toParent: self)
        }
        else if(mainLeftMenuVC != nil){
            view.insertSubview(mainRightMenuVC.view, aboveSubview: mainLeftMenuVC.view)
        }

        isExpandRight = !isExpandRight
        if(menuOption == nil){
            animatePanel(shouldExpand: isExpandRight, side: nil, menuOption: menuOption)
        }
        else{
            //let networkSettingVC = NetworkSettingVC()
            //self.present(UINavigationController(rootViewController: networkSettingVC), animated: true)
            proceedToView(side: "", menuOption: menuOption)
        }
    }

    func mainViewClicked() {
        isExpandRight = false
        isExpandLeft = false
        animatePanel(shouldExpand: false, side: "left", menuOption: nil)
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
}