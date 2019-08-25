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
        case .Welcome: return "\n안녕하세요,\nMOAH Wallet 입니다."
        case .WalletNetwork: return "네트워크 설정"
        case .WalletMnemonic: return "비밀 시드 구문"
        case .WalletPassword: return "보안 및 알림"
        case .CSNotice: return "공지사항"
        case .CSFAQ: return "FAQ"
        case .CSAgreement: return "약관 및 정책"
        case .CSEmail: return "이메일 문의하기"
        }
    }
}
