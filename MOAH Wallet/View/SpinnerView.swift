//
// Created by 김경인 on 2019-08-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class SpinnerView: CAShapeLayer {
    convenience init(center: CGPoint){
        self.init()

        let circularPath = UIBezierPath(arcCenter: center, radius: 100,
                startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        path = circularPath.cgPath
        strokeColor = UIColor(key: "light2").cgColor
        fillColor = UIColor.clear.cgColor
        lineCap = .round
        lineWidth = 3
        strokeEnd = 0

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.repeatCount = Float.infinity
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        add(basicAnimation, forKey: "strokeEnd")

    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
