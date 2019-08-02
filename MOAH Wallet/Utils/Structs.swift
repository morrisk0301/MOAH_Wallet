//
// Created by 김경인 on 2019-07-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import BigInt

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

struct CustomAddress: Codable {
    var address: String
    var name: String
    var isPrivateKey: Bool
}

struct CustomGas: Codable {
    var rate: String
    var price: BigUInt?
    var limit: BigUInt?
}