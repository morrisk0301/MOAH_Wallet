//
// Created by 김경인 on 2019-08-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

enum LockTime: Int {

    case first
    case second
    case third
    case more

    var time: Double {
        switch self {
        case .first: return 600.0
        case .second: return 1800.0
        case .third: return 3600.0
        case .more: return 86400.0
        }
    }
}