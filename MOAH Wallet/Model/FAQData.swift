//
// Created by 김경인 on 2019-08-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

enum FAQData {

    enum account: Int, CaseIterable {
        case account1
        case account2
        case account3
        case account4
        case account5
        case account6

        var question: String {
            switch (self) {
            case .account1:
                return "계정은 어떻게 생성하나요?"
            case .account2:
                return "타 지갑의 개인키로 계정을 불러오고 싶습니다. 어떻게 하나요?"
            case .account3:
                return "계정을 삭제하고 싶습니다. 어떻게 하나요?"
            case .account4:
                return "계정은 몇 개 까지 보유할 수 있나요?"
            case .account5:
                return "계정의 지갑 주소는 어떻게 확인하나요?"
            case .account6:
                return "시드 구문으로 지갑을 복원하고 싶습니다. 어떻게 하나요?"
            }
        }

        var answer: String {
            switch (self) {
            case .account1:
                return "메인화면 좌측 메뉴 -> 내 계정 -> 계정 추가 -> 계정 생성에서 생성할 수 있습니다."
            case .account2:
                return "메인화면 좌측 메뉴 -> 내 계정 -> 계정 추가 -> 개인키로 가져오기에서 가져올 수 있습니다. 가져온 계정은 본 계정과 시드 구문이 다른 점 유의하시기 바랍니다."
            case .account3:
                return "메인화면 좌측 메뉴 -> 내 계정에서 계정을 좌측으로 스와이프 하시면 삭제 버튼이 나타납니다."
            case .account4:
                return "계정은 10개까지 생성할 수 있으며, 개인키로 가져온 계정의 개수 제한은 없습니다."
            case .account5:
                return "메인화면 좌측 메뉴를 클릭하시면 계정의 주소와 QR Code를 확인하실 수 있습니다. Address 버튼을 누르면 계정 주소를 복사할 수 있습니다."
            case .account6:
                return "MOAH Wallet을 삭제 및 재설치 후, 지갑 복원하기 버튼을 클릭하여 진행해주시기 바랍니다."
            }
        }
    }

    enum token: Int, CaseIterable {
        case token1
        case token2
        case token3
        case token4
        case token5

        var question: String {
            switch (self) {
            case .token1:
                return "토큰이 무엇인가요?"
            case .token2:
                return "토큰은 어디서 추가하나요?"
            case .token3:
                return "컨트랙트 주소로 코인을 추가하고 싶습니다. 어떻게 하나요?"
            case .token4:
                return "테스트넷에서도 토큰을 검색할 수 있나요?"
            case .token5:
                return "추가한 토큰을 삭제하고 싶습니다. 어떻게 하나요?"
            }
        }

        var answer: String {
            switch (self) {
            case .token1:
                return "토큰은 Ethereum의 스마트 컨트랙트를 이용하여 생성된 암호화폐입니다."
            case .token2:
                return "메인 화면 암호화폐 명 클릭 -> 추가 -> 토큰 검색에서 원하는 토큰을 검색하여 추가할 수 있습니다."
            case .token3:
                return "메인 화면 암호화폐 명 클릭 -> 추가 -> 토큰 검색 -> 토큰 직접 추가에서 컨트랙트 주소로 토큰을 추가할 수 있습니다."
            case .token4:
                return "토큰 검색은 Ethereum 메인넷만 지원합니다."
            case .token5:
                return "메인 화면 암호화폐 명 클릭 후 추가된 토큰을 왼쪽으로 스와이프 하시면 삭제 버튼이 나타납니다."
            }
        }
    }

    enum transfer:Int, CaseIterable {
        case transfer1
        case transfer2
        case transfer3
        case transfer4
        case transfer5
        case transfer6

        var question: String {
            switch (self) {
            case .transfer1:
                return "암호화폐는 어떻게 전송하나요?"
            case .transfer2:
                return "왜 전송이 실패하나요?"
            case .transfer3:
                return "가스 비용이 무엇인가요?"
            case .transfer4:
                return "가스 가격이 무엇인가요?"
            case .transfer5:
                return "가스 한도가 무엇인가요?"
            case .transfer6:
                return "가스 비용은 어디서 설정하나요?"
            }
        }

        var answer: String {
            switch (self) {
            case .transfer1:
                return "메인 화면에서 전송 버튼을 클릭하면 전송할 수 있습니다. 암호화폐는 어떠한 경우에도 전송이 취소될 수 없습니다. 신중하게 거래해주세요."
            case .transfer2:
                return "전송 실패는 지갑 주소 오류, 수수료 과다/부족, 블록체인 네트워크 오류 또는 토큰에 락이 걸려있는 경우 발생할 수 있습니다. MOAH Wallet은 전송 실패한 거래애 사용된 가스 비용을 책임지지 않습니다."
            case .transfer3:
                return "가스 비용은 Ethereum 네트워크안에 데이터를 기록하는 비용입니다. 암호화폐 전송시에 지불해야 하며, 가스 가격 * 가스 한도로 구성됩니다."
            case .transfer4:
                return "가스 비용에 따라 암호화폐의 전송 속도가 정해집니다. 가스 비용을 높게 설정하면 전송 속도가 빨라지며, 낮게 설정하면 전송 속도가 느려집니다."
            case .transfer5:
                return "가스 한도는 사용할 가스의 최대 값을 의미합니다. 암호화폐 거래시 계정에서 가스 한도 만큼 가스가 인출되며, 사용 후 남은 가스는 반환됩니다."
            case .transfer6:
                return "메인화면 좌측 메뉴 -> TX Fee에서 설정할 수 있습니다."
            }
        }
    }

    enum security:Int, CaseIterable {
        case security1
        case security2
        case security3
        case security4
        case security5
        case security6

        var question: String{
            switch(self){
            case .security1:
                return "시드 구문이 무엇인가요?"
            case .security2:
                return "시드 구문은 어떻게 확인하나요?"
            case .security3:
                return "개인키는 무엇인가요?"
            case .security4:
                return "개인키는 어떻게 확인하나요?"
            case .security5:
                return "비밀번호는 어떻게 변경하나요?"
            case .security6:
                return "비밀번호를 분살히였습니다. 어떻게 하나요?"
            }
        }

        var answer: String{
            switch(self){
            case .security1:
                return "시드 구문은 12개의 영문 단어로 이루어진 개인키입니다. 시드 구문은 지갑 복원, 암호화폐 전송 등에 사용되므로 절대 타인에게 유출하지 않으시길 바랍니다."
            case .security2:
                return "메인화면 우측 메뉴 -> 보안 비밀 시드 구문 -> 시드 구문 조회에서 확인가능합니다."
            case .security3:
                return "개인키는 지갑의 각 계정별로 생성된 해시 값입니다. 개인키는 지갑 연동, 암호화폐 전송 등에 사용되므로 절대 타인에게 유출하지 않으시길 바랍니다."
            case .security4:
                return "메인화면 좌측 메뉴 -> 개인키 조회에서 확인가능합니다."
            case .security5:
                return "메인화면 우측 메뉴 -> 보안 및 알림 -> 비밀번호 변경에서 변경하실 수 있습니다."
            case .security6:
                return "MOAH Wallet은 사용자의 비밀번호를 저장하지 않기 때문에 비밀번호를 다시 찾을 수 없습니다. 앱을 재설치 후 백업한 시드 구문으로 복원을 진행해주세요."
            }
        }
    }
}
