//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import web3swift
import CoreData
import BigInt

class MainContainerVC: UIViewController, MainControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, TransactionDelegate{

    var isExpandLeft = false
    var isExpandRight = false
    var signUp = false
    var isInit = true
    var isReload = false
    var tempMnemonic: String?
    var symbol = "ETH"
    var decimals = 18
    var mainLeftMenuVC: MainLeftMenuVC!
    var mainRightMenuVC: MainRightMenuVC!
    var tokenSelectVC: TokenSelectVC!
    var centerController: UIViewController!
    var mainVC: MainVC!
    var transparentView = UIView()
    var style:UIStatusBarStyle = .default
    var txHistory: [TXInfo]?

    let txQueue = TXQueue.queue
    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.shared
    let util = Util()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isReload = true

        self.style = .lightContent

        mainVC = MainVC()
        mainVC.signUp = self.signUp
        mainVC.tempMnemonic = self.tempMnemonic
        mainVC.delegate = self
        mainVC.mainTopView.tokenView.delegate = self
        centerController = UINavigationController(rootViewController: mainVC)

        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)

        txQueue.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isReload){
            if(isInit){
                account.connectNetwork()
                txQueue.refreshTX()
            }
            initVCs()
            loadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.style = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
        if(isReload){
            self.showSpinner()
        }
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
            if(self.isInit){
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

            self.tokenSelectVC = TokenSelectVC()
            self.tokenSelectVC.delegate = self
            self.tokenSelectVC.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.screenSize.height/2)
            self.addChild(self.tokenSelectVC)
            self.tokenSelectVC.didMove(toParent: self)

            self.isInit = false
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
        case .CSNotice:
            let controller = NoticeVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSFAQ:
            let controller = FAQVC()
            present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        case .CSAgreement:
            let controller = PolicyVC()
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

        view.addSubview(tokenSelectVC.view)
        animatePanel(shouldExpand: true, side: "down", menuOption: nil)
    }

    func tokenEnded(selected: Bool) {
        proceedAfterTokenView(add: !selected, selected: selected)
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

    func loadData(){
        DispatchQueue.global(qos: .userInitiated).async{
            let ethToken = EthToken.shared
            let web3 = CustomWeb3.shared
            let networkPredicate = NSPredicate(format: "network = %@", web3.network!.name)
            let tokenArray = ethToken.fetchToken(networkPredicate)
            let ethTxHistory = EthTXHistory()

            var name = "Ethereum"
            if(ethToken.token != nil){
                self.symbol = ethToken.token!.symbol
                self.decimals = ethToken.token!.decimals
                name = ethToken.token!.name
            }else{
                self.symbol = "ETH"
                self.decimals = 18
            }
            self.checkChainNetwork()
            self.txHistory = ethTxHistory.fetchTXInfo()
            web3.getBalance(address: nil, completion: {(ethBalance, tokenBalance) in
                var finalBalance: BigUInt!
                if(ethToken.token != nil) {
                    finalBalance = tokenBalance
                }
                else{
                    finalBalance = ethBalance
                }
                let balanceTrimmed = self.util.trimBalance(balance: finalBalance, index: 24)
                    DispatchQueue.main.async {
                        self.mainVC.ethBalance = ethBalance
                        self.mainVC.balance = finalBalance
                        self.mainVC.symbol = self.symbol
                        self.mainVC.decimals = self.decimals
                        self.mainVC.txHistory = self.txHistory!
                        self.mainVC.mainTopView.tokenView.setTokenString(tokenString: name)
                        self.mainVC.balanceString = balanceTrimmed
                        self.mainVC.mainTopView.balanceLabel.text = balanceTrimmed + " " + self.symbol
                        self.mainVC.txView.reloadData()
                        self.tokenSelectVC.tokenArray = tokenArray
                        self.tokenSelectVC.tableView.reloadData()
                        self.isReload = false
                        self.hideSpinner()
                        self.mainVC.refreshControl.endRefreshing()
                        self.hideTransparentView()
                    }
            })
        }
    }

    func checkChainNetwork(){
        let web3: CustomWeb3 = CustomWeb3.shared
        if(web3.getWeb3Ins() == nil){
            DispatchQueue.main.async {
                self.hideSpinner()
                let alertVC = self.util.alert(title: "Error".localized, body: "Block chain network is unreachable.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: { _ in
                    DispatchQueue.main.async {
                        let controller = NetworkSettingVC()
                        self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
                    }
                })
                self.present(alertVC, animated: false)
            }
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

    func sendEmail(){
        if(MFMailComposeViewController.canSendMail()){
            let emailTitle = ""
            let messageBody = "iPhone Model".localized + ": \n" + "IOS Version".localized + ": \n" + "Problem".localized + ": "
            let toRecipents = ["moahwallet_official@naver.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            present(mc, animated: true, completion: nil)
        }
        else{
            let alertVC = util.alert(title: "Error".localized, body: "Mail App is unavailable.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in
                return
            })
            self.present(alertVC, animated: false)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true)
    }

    func proceedAfterTokenView(add: Bool, selected: Bool){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tokenSelectVC.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.screenSize.height/2)
        }, completion: {_ in
            self.transparentView.removeFromSuperview()
            self.tokenSelectVC.removeFromParent()
            if(add){
                let controller = TokenListVC()
                self.present(UINavigationController(rootViewController: controller), animated: true)
            }
            else if(selected || self.isReload){
                self.showSpinner()
                self.loadData()
            }
        })
    }

    func transactionComplete() {
        DispatchQueue.main.async{
            self.showSpinner()
            self.loadData()
        }
    }

    func reload() {
        self.showTransparentView()
        txQueue.refreshTX()
        self.loadData()
    }

    func willReload() {
        self.isReload = true
    }

    @objc private func mainViewClicked(_ sender: UIGestureRecognizer) {
        isExpandRight = false
        isExpandLeft = false
        animatePanel(shouldExpand: false, side: nil, menuOption: nil)
    }

    @objc private func transparentViewClicked(_ sender: UITapGestureRecognizer){
        proceedAfterTokenView(add: false, selected: false)
    }

}