//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class DownTransition: CATransition {
    override init() {
        super.init()
        duration = 0.5
        type = CATransitionType.moveIn
        subtype = CATransitionSubtype.fromBottom
        timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
