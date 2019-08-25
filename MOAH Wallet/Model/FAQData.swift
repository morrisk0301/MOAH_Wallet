//
// Created by 김경인 on 2019-08-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

enum FAQData {

    enum account: Int{
        case account1
        case account2
        case account3
        case account4

        var question: String{
            switch(self){
            case .account1:
                return ""
            case .account2:
                return ""
            case .account3:
                return ""
            case .account4:
                return ""
            }
        }

        var answer: String{
            switch(self){
            case .account1:
                return ""
            case .account2:
                return ""
            case .account3:
                return ""
            case .account4:
                return ""
            }
        }
    }
    enum wallet {
        case wallet1
        case wallet2
        case wallet3
        case wallet4

        var question: String {
            switch (self) {
            case .wallet1:
                return ""
            case .wallet2:
                return ""
            case .wallet3:
                return ""
            case .wallet4:
                return ""
            }
        }

        var answer: String {
            switch (self) {
            case .wallet1:
                return ""
            case .wallet2:
                return ""
            case .wallet3:
                return ""
            case .wallet4:
                return ""
            }
        }
    }
    enum token{
        case token1
        case token2
        case token3
        case token4

        var question: String{
            switch(self){
            case .token1:
                return ""
            case .token2:
                return ""
            case .token3:
                return ""
            case .token4:
                return ""
            }
        }

        var answer: String{
            switch(self){
            case .token1:
                return ""
            case .token2:
                return ""
            case .token3:
                return ""
            case .token4:
                return ""
            }
        }
    }
    enum tokenTransfer{
        case tt1
        case tt2
        case tt3
        case tt4

        var question: String{
            switch(self){
            case .tt1:
                return ""
            case .tt2:
                return ""
            case .tt3:
                return ""
            case .tt4:
                return ""
            }
        }

        var answer: String{
            switch(self){
            case .tt1:
                return ""
            case .tt2:
                return ""
            case .tt3:
                return ""
            case .tt4:
                return ""
            }
        }
    }
}
