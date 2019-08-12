//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

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

protocol QRCodeReadDelegate {
    func qrCodeRead(value: String)
}

protocol Observer {
    func networkChanged(network: CustomWeb3Network)
    func networkAdded(network: CustomWeb3Network)
    func tokenChanged(token: CustomToken)
    func tokenAdded(token: CustomToken)
    func addressChanged(account: CustomAddress)
    func addressAdded(account: CustomAddress)
}

protocol NetworkObserver {
    var id : String { get set }
    func networkChanged(network: CustomWeb3Network)
}
