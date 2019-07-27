//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenuOption: Int, CustomStringConvertible {
    case AccountName
    case MyAccount
    case PrivateKey

    var description: String {
        switch self {
        case .AccountName: return "주 계정"
        case .MyAccount: return "내 계정"
        case .PrivateKey: return "개인키 조회"
        }
    }
}
