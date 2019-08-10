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
    func tokenAddClicked()
    func txFeeClicked()
    func getBalance()
    func isSignUp()
}

protocol QRCodeReadDelegate {
    func qrCodeRead(value: String)
}