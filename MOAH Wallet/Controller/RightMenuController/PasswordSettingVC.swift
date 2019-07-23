//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class PasswordSettingVC: UIViewController {
    let lock: LockView = {
        let lockView = LockView()
        lockView.translatesAutoresizingMaskIntoConstraints = false

        return lockView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "비밀번호 및 인증 관리")
        self.clearNavigationBar()

        view.backgroundColor = .white
        view.addSubview(lock)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        lock.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lock.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lock.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lock.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

    @objc func backPressed(_ sender: UIButton){
        let transition = RightTransition()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
}
