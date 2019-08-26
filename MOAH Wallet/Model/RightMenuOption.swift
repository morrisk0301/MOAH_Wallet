//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

enum RightMenuOption: Int, CustomStringConvertible {
    case Welcome
    case WalletNetwork
    case WalletMnemonic
    case WalletPassword
    case CSNotice
    case CSFAQ
    case CSAgreement
    case CSEmail

    var description: String {
        switch self {
        case .Welcome: return "\nWelcome,\nThis is MOAH Wallet!".localized
        case .WalletNetwork: return "Network Settings".localized
        case .WalletMnemonic: return "Memonic Phrase".localized
        case .WalletPassword: return "Security and Notifications".localized
        case .CSNotice: return "Notice".localized
        case .CSFAQ: return "FAQ"
        case .CSAgreement: return "Terms and Policy".localized
        case .CSEmail: return "Email Inquiry".localized
        }
    }
}
