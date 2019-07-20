//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MainContainerVC: UIViewController, MainControllerDelegate{

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

    private func animatePanel(shouldExpand: Bool, side: String) {

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
            }) { (_) in

            }
        }
        /*
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
        */

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
        animatePanel(shouldExpand: isExpandLeft, side: "left")
    }

    func rightSideMenuClicked() {
        if(mainRightMenuVC == nil){
            mainRightMenuVC = MainRightMenuVC()
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
        animatePanel(shouldExpand: isExpandRight, side: "right")
    }

    func mainViewClicked() {
        isExpandRight = false
        isExpandLeft = false
        animatePanel(shouldExpand: false, side: "left")
    }
}

protocol MainControllerDelegate{
    func leftSideMenuClicked()
    func rightSideMenuClicked()
    func mainViewClicked()
}