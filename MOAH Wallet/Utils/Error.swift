//
// Created by 김경인 on 2019-07-29.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation

enum GetAccountError: Error {
    case invalidPrivateKey
    case existingAccount
}

enum AddNetworkError: Error {
    case invalidName
    case invalidURL
    case invalidNetwork
}

enum TransferError: Error {
    case invalidAmount
    case insufficientAmount
    case invalidAddress
    case transferToSelf
    case gasError
}

enum GetTokenError: Error {
    case invalidAddress
    case tokenNil
    case existingToken
    case unidentifiedError
}