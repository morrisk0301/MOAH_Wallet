//
// Created by 김경인 on 2019-07-11.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

class Util {
    init(){}

    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
