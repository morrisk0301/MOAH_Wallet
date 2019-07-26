//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenuOption: Int, CustomStringConvertible {
    case Account
    case WalletNetwork
    case WalletMnemonic
    case WalletPassword
    case CSAnnouncement
    case CSFAQ
    case CSAgreement
    case CSEmail

    var description: String {
        switch self {
        case .Account: return "\n안녕하세요,\nMOAH Wallet 입니다."
        case .WalletNetwork: return "네트워크 관리"
        case .WalletMnemonic: return "시드 구문 관리"
        case .WalletPassword: return "비밀번호 및 인증 관리"
        case .CSAnnouncement: return "공지사항"
        case .CSFAQ: return "FAQ"
        case .CSAgreement: return "약관 및 정책"
        case .CSEmail: return "이메일 문의하기"
        }
    }
}
