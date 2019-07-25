//
// Created by 김경인 on 2019-07-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TransparentButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupButton(){
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 20, dynamic: true)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
