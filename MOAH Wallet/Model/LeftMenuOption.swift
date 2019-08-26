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
    case TxFee

    var description: String {
        switch self {
        case .AccountName: return "Main Account".localized
        case .MyAccount: return "My Account".localized
        case .PrivateKey: return "View Private Key".localized
        case .TxFee: return ""
        }
    }
}
