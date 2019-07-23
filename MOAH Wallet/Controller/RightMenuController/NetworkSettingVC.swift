//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NetworkSettingVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "네트워크 관리")
        self.clearNavigationBar()

        view.backgroundColor = .white
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){

    }

    @objc func backPressed(_ sender: UIButton){
        let transition = RightTransition()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
}
