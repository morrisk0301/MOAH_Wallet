//
// Created by 김경인 on 2019-07-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

struct CustomAddress: Codable {
    var address: String
    var name: String
    var isPrivateKey: Bool
    var path: String
}

struct CustomGas: Codable {
    var rate: String
    var price: BigUInt?
    var limit: BigUInt?
}

struct CustomToken: Codable {
    var name: String
    var symbol: String
    var address: String
    var decimals: Int
    var network: String
    var logo: Data?
}

struct CustomWeb3Network: Codable {
    var name: String
    var url: URL
}

struct NetworkData: Codable {
    var network: String
    var tokenSelected: CustomToken?
}

struct TransferInfo {
    var amount: BigUInt
    var address: String
    var gas: BigUInt
    var total: BigUInt
    var symbol: String
    var decimals: Int
}

struct TXSubInfo {
    var to: String
    var from: String
    var category: String
    var amount: BigUInt
    var symbol: String
    var decimals: Int
    var gasPrice: BigUInt
    var gasLimit: BigUInt
}

func ==(left: CustomWeb3Network, right: CustomWeb3Network) -> Bool{
    if(left.name == right.name && left.url == right.url){
        return true
    }
    return false
}