//
// Created by 김경인 on 2019-07-11.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class Util {
    init(){}

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func alert(title: String, body: String, buttonTitle: String, completion: @escaping (Bool) -> Void) -> AlertVC {
        let alertViewController = AlertVC()

        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.alertTitle = title
        alertViewController.alertBody = body
        alertViewController.alertButtonTitle = buttonTitle
        alertViewController.buttonAction = completion

        return alertViewController
    }

    func generateQRCode(source: String?) -> UIImage? {

        guard let sourceString: String = source else {return nil}

        let data = sourceString.data(using: String.Encoding.ascii)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrImage = qrFilter.outputImage else { return nil }

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)

        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil }

        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil }

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: outputCIImage.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage)

        return processedImage
    }
}
