//
// Created by 김경인 on 2019-07-29.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TXFeeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "전송 수수료 설정")
        self.replaceBackButton(color: "dark")

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        view.backgroundColor = UIColor(key: "light3")

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){

    }

    @objc func backPressed(_ sender: UIButton){
        self.dismiss(animated: false)
    }
}
