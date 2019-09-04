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
                return "How do I create a new account?".localized
            case .account2:
                return "How do I get external account with private key?".localized
            case .account3:
                return "How do I delete my account?".localized
            case .account4:
                return "What is the maximum number of accounts in my wallet?".localized
            case .account5:
                return "How do I find my account's address?".localized
            case .account6:
                return "How do I restore my external wallet with mnemonic phrase?".localized
            }
        }

        var answer: String {
            switch (self) {
            case .account1:
                return "You can create a new account in left tab of main menu -> My Account -> Add Account -> Create Account menu.".localized
            case .account2:
                return "You can get your external account with private key in left tab of main menu -> My Account -> Add Account -> Get Account with Private Key menu.".localized
            case .account3:
                return "You can delete your account in left tab of main menu -> My Account menu by swiping left on your account list.".localized
            case .account4:
                return "Maximum number of accounts to be created is 10. There is no limit for getting external account with private key.".localized
            case .account5:
                return "You can find your accounts' address and it's QR Code in left tab of main menu".localized
            case .account6:
                return "You need to delete and reinstall MOAH Wallet in order to restore an external wallet.".localized
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
                return "What is a token?".localized
            case .token2:
                return "How do I add a token?".localized
            case .token3:
                return "How do I add token with it's contract address?".localized
            case .token4:
                return "Can I search tokens in test network?".localized
            case .token5:
                return "How do I remove token that I have added?".localized
            }
        }

        var answer: String {
            switch (self) {
            case .token1:
                return "A token is a crypto currency created with Ethereum's Smart Contract.".localized
            case .token2:
                return "Click the name of crypto currency in main menu -> Click add -> Search the name of the token you wish to add.".localized
            case .token3:
                return "Click the name of crypto currency in main menu -> Click add -> Custom Token -> Enter contract address of the token you wish to add.".localized
            case .token4:
                return "Token searching is only available in Ethereum main network.".localized
            case .token5:
                return "Click the name of crypto currency in main menu -> Swipe left on your token list and click delete button.".localized
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
                return "How do I transfer my Ether/Token?".localized
            case .transfer2:
                return "Why does my transaction fails?".localized
            case .transfer3:
                return "What is gas fee?".localized
            case .transfer4:
                return "What is gas price?".localized
            case .transfer5:
                return "What is gas limit?".localized
            case .transfer6:
                return "How do I set my gas fee?".localized
            }
        }

        var answer: String {
            switch (self) {
            case .transfer1:
                return "Click transfer button on the main menu. Ether/Token transfers cannot be undone under any circumstances. Please beware of this.".localized
            case .transfer2:
                return "Invalid address, insufficient/excessive gas fee, block chain network error, or lock on your token can cause your transaction to fail. MOAH Wallet has no responsibility on gas fee of a failed transaction.".localized
            case .transfer3:
                return "Gas fee is a cost for making a transaction in Ethereum block chain network. Gas fee is a product of gas price and gas limit".localized
            case .transfer4:
                return "Gas price is amount of Ether per gas. Transaction speed is proportional to gas price.".localized
            case .transfer5:
                return "Gas limit is maximum amount of gas per transaction. Maximum amount of gas is withdrawn when making transaction and leftover gas will be refunded after transaction is complete.".localized
            case .transfer6:
                return "You can set your gas fee in left tab of main menu -> TX Fee".localized
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
                return "What is mnemonic phrase?".localized
            case .security2:
                return "How do I find my mnemonic phrase?".localized
            case .security3:
                return "What is private key?".localized
            case .security4:
                return "How do I find my private key?".localized
            case .security5:
                return "How do I change my app password?".localized
            case .security6:
                return "I have lost my password. What can I do?".localized
            }
        }

        var answer: String{
            switch(self){
            case .security1:
                return "Mnemonic phrase is a private key consists of 12 words. It is used to create/restore wallet and transfer Ether/Token. Be careful not to disclose it.".localized
            case .security2:
                return "You can find your mnemonic phrase in right tab of main menu -> Mnemonic Phrase -> View Mnemonic Phrase.".localized
            case .security3:
                return "Private key is a unique hash value for your account. It is used to getting external account and transfer Ether/Token. Be careful not to disclose it.".localized
            case .security4:
                return "You can find your private key in left tab of main menu -> View Private Key.".localized
            case .security5:
                return "You can change your app password in right tab of main menu -> Security and Notifications.".localized
            case .security6:
                return "MOAH Wallet does not store user's password. Please reinstall application and restore your wallet with mnemonic phrase.".localized
            }
        }
    }
}
