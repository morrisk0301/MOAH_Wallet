//
// Created by 김경인 on 2019-07-11.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import CoreImage
import BigInt
import web3swift
import UIKit

class Util {
    init(){}

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func alert(title: String, body: String, buttonTitle: String, buttonNum: Int, completion: @escaping (Bool) -> Void) -> AlertVC {
        let alertViewController = AlertVC()

        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.alertTitle = title
        alertViewController.alertBody = body
        alertViewController.alertButtonTitle = buttonTitle
        alertViewController.buttonAction = completion
        alertViewController.buttonNum = buttonNum

        return alertViewController
    }

    func alert(use: String, title: String, info: TransferInfo, balance: BigUInt, isToken: Bool, buttonTitle: String, buttonNum: Int, completion: @escaping (Bool) -> Void) -> AlertVC {
        let alertViewController = AlertVC()

        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.alertTitle = title
        alertViewController.alertButtonTitle = buttonTitle
        alertViewController.buttonAction = completion
        alertViewController.buttonNum = buttonNum
        alertViewController.info = info
        alertViewController.isToken = isToken
        alertViewController.balance = balance
        alertViewController.use = use

        return alertViewController
    }

    func trimBalance(balance: BigUInt?) -> String {
        if(balance == nil || balance == 0){
            return "0.00000"
        }
        var balanceString = Web3Utils.formatToEthereumUnits(balance!, toUnits: .eth)!
        if(balanceString.count > 24){
            balanceString.removeLast(balanceString.count - 24)
            balanceString += "..."
        }

        return balanceString
    }

    func trimZero(balance: String?) -> String {
        guard var trimString = balance else {return "0"}
        if(!trimString.contains(".")){return trimString}
        while(trimString.last == "0"){
            trimString.removeLast()
        }
        return trimString
    }

    func returnStringDecimalCount(string: String) -> Int{
        if(Int(string) != nil){
            return 0
        }
        else{
            let stringArr = string.components(separatedBy: ".")
            print(stringArr)
            return 0
        }
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
