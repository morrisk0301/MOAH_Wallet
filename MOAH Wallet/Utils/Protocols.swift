//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

protocol KeypadViewDelegate {
    func cellPressed(_ cellItem: String)
    func delPressed()
}

protocol MainControllerDelegate {
    func leftSideMenuClicked()
    func rightSideMenuClicked(forMenuOption menuOption: RightMenuOption?)
    func mainViewClicked()
}

protocol TokenViewDelegate {
    func tokenViewClicked()
}