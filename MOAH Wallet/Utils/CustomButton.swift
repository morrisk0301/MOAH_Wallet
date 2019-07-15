//
// Created by 김경인 on 2019-07-15.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        //backgroundColor = UIColor(rgb: 0x005FB2)
        backgroundColor = UIColor(rgb: 0x0067E2)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        //layer.borderWidth = 2.0
        //layer.borderColor = UIColor.white.cgColor
        setTitleColor(.white, for: .normal)
    }
}