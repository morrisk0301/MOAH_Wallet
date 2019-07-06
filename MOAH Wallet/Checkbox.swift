//
// Created by 김경인 on 2019-07-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton {
    convenience init() {
        self.init(frame: .zero)
        self.setImage(UIImage(named: "unchecked"), for: .normal)
        self.setImage(UIImage(named: "checked"), for: .selected)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        self.isSelected = !self.isSelected
    }
}