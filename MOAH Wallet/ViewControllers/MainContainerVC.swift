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

    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = MainVC()
        mainVC.signUp = self.signUp
        mainVC.tempMnemonic = self.tempMnemonic
        mainVC.delegate = self
        let centerController = UINavigationController(rootViewController: mainVC)

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
                    self.view.frame.origin.x = self.view.frame.width - self.screenSize.width/5
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.view.frame.origin.x = -(self.view.frame.width - self.screenSize.width/5)
                }, completion: nil)
            }

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.frame.origin.x = 0
            }) { (_) in

            }
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)

    }

    func leftSideMenuClicked() {
        if(!isExpandLeft){
            let mainLeftMenuVC = MainLeftMenuVC()
            view.insertSubview(mainLeftMenuVC.view, at: 0)
            addChild(mainLeftMenuVC)
            mainLeftMenuVC.didMove(toParent: self)
        }

        isExpandLeft = !isExpandLeft
        animatePanel(shouldExpand: isExpandLeft, side: "left")
    }

    func rightSideMenuClicked() {
        if(!isExpandRight){
            let mainRightMenuVC = MainRightMenuVC()
            view.insertSubview(mainRightMenuVC.view, at: 0)
            addChild(mainRightMenuVC)
            mainRightMenuVC.didMove(toParent: self)
        }

        isExpandRight = !isExpandRight
        animatePanel(shouldExpand: isExpandRight, side: "right")
    }
}

protocol MainControllerDelegate{
    func leftSideMenuClicked()
    func rightSideMenuClicked()
}