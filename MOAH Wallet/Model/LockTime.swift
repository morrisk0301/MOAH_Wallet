//
// Created by 김경인 on 2019-08-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

enum LockTime: Int {

    case first
    case second
    case third
    case fourth
    case more

    var time: Double {
        switch self {
        case .first: return 60.0
        case .second: return 600.0
        case .third: return 3600.0
        case .fourth: return 43200.0
        case .more: return 86400.0
        }
    }
}