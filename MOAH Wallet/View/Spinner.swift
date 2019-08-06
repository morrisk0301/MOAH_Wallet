//
// Created by 김경인 on 2019-08-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class Spinner: UIView {

    private var foregroundLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!

    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height

        let lineWidth = 0.1 * min(width, height)

        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor(key: "grey2").cgColor, fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        foregroundLayer.strokeEnd = 0

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 1
        basicAnimation.toValue = 1
        basicAnimation.repeatCount = Float.infinity
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards

        foregroundLayer.add(basicAnimation, forKey: "strokeEnd")

        layer.addSublayer(foregroundLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alpha = 0.3
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createCircularLayer(rect: CGRect, strokeColor: CGColor,
                                     fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {

        let width = rect.width
        let height = rect.height

        let center = CGPoint(x: width / 2, y: height / 2)

        let circularPath = UIBezierPath(arcCenter: center, radius: 15, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)

        let shapeLayer = CAShapeLayer()

        shapeLayer.path = circularPath.cgPath

        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round

        return shapeLayer
    }
}
