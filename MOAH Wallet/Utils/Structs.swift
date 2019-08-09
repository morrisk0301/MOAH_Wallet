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
    var path: String?
}

struct CustomGas: Codable {
    var rate: String
    var price: BigUInt?
    var limit: BigUInt?
}

struct CustomWeb3Network: Codable {
    var name: String
    var url: URL
}

struct TransferInfo: Codable {
    var amount: BigUInt
    var address: String
    var gas: BigUInt
    var total: BigUInt
    var symbol: String
}