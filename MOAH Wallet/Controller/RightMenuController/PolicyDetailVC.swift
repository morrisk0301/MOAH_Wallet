//
// Created by 김경인 on 2019-08-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class PolicyDetailVC: UIViewController {

    let screenSize = UIScreen.main.bounds
    var type: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: type)

        view.backgroundColor = UIColor(key: "light3")

        setupLayout()
    }

    private func setupLayout(){

    }
}
