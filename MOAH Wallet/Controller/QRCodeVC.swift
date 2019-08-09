//
// Created by 김경인 on 2019-08-09.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class QRCodeVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "QR Code 인식")
        self.transparentNavigationBar()

        view.backgroundColor = UIColor(key: "light3")
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){

    }
}
