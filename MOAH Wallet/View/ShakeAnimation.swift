//
// Created by 김경인 on 2019-07-29.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class ShakeAnimation: CABasicAnimation {
    override init() {
        super.init()
        let midX = UIScreen.main.bounds.midX
        let midY = UIScreen.main.bounds.midY

        duration = 0.06
        repeatCount = 4
        autoreverses = true
        fromValue = CGPoint(x: midX - 10, y: midY)
        toValue = CGPoint(x: midX + 10, y: midY)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
