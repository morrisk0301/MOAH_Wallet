//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import web3swift

protocol KeypadViewDelegate {
    func cellPressed(_ cellItem: String)
    func delPressed()
}

protocol MainControllerDelegate {
    func leftSideMenuClicked(forMenuOption menuOption: LeftMenuOption?)
    func rightSideMenuClicked(forMenuOption menuOption: RightMenuOption?)
    func tokenViewClicked()
    func tokenEnded(selected: Bool)
    func txFeeClicked()
    func isSignUp()
}

protocol TransactionDelegate {
    func transactionComplete()
}

protocol QRCodeReadDelegate {
    func qrCodeRead(value: String)
}

protocol NetworkObserver {
    var id : String { get set }
    func networkChanged(network: CustomWeb3Network)
}

protocol AddressObserver {
    var id : String { get set}
    func addressChanged(address: CustomAddress)
}

protocol TokenObserver {
    var id : String { get set}
    func tokenChanged(token: CustomToken?)
}

