//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class PasswordChangeVC: UIViewController, KeypadViewDelegate {

    var passwordNew: String?
    var password: String = ""
    var changeStatus = 0
    let account: EthAccount = EthAccount.accountInstance
    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    let userDefaults = UserDefaults.standard

    let lock: LockView = {
        let lockView = LockView()
        lockView.translatesAutoresizingMaskIntoConstraints = false

        return lockView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "light")
        self.transparentNavigationBar()

        view.addSubview(lock)
        lock.secureKeypad.delegate = self

        if(changeStatus == 0){
            lock.passwordLabel.text = "기존 비밀번호를 입력해주세요."
        }
        else if(changeStatus == 1){
            lock.passwordLabel.text = "새로운 비밀번호를 입력해주세요."
        }
        else if(changeStatus == 2){
            lock.passwordLabel.text = "비밀번호를 한번 더 입력해주세요."
        }

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        let changeImage = UIImage(named: "pwLine")

        lock.errorLabel.text = ""
        password = ""

        lock.pwLine6.image = changeImage
        lock.pwLine5.image = changeImage
        lock.pwLine4.image = changeImage
        lock.pwLine3.image = changeImage
        lock.pwLine2.image = changeImage
        lock.pwLine.image = changeImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    private func setupLayout(){
        lock.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lock.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lock.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lock.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func cellPressed(_ cellItem: String) {
        password.append(cellItem)
        lock.changeLabel(password.count)

        if(changeStatus == 0){
            if(password.count >= 6){
                if(account.checkPassword(password)){
                    let controller = PasswordChangeVC()
                    controller.changeStatus = changeStatus + 1
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else{
                    password = ""
                    let changeImage = UIImage(named: "pwLine")
                    let animation = ShakeAnimation()
                    self.view.layer.add(animation, forKey: "position")

                    lock.errorLabel.text = "비밀번호가 일치하지 않습니다.\n5회 오류시 지갑이 초기화됩니다."
                    lock.pwLine6.image = changeImage
                    lock.pwLine5.image = changeImage
                    lock.pwLine4.image = changeImage
                    lock.pwLine3.image = changeImage
                    lock.pwLine2.image = changeImage
                    lock.pwLine.image = changeImage
                }
            }
        }
        else if(changeStatus == 1){
            if(password.count >= 6) {
                let controller = PasswordChangeVC()
                controller.passwordNew = password
                controller.changeStatus = changeStatus + 1
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        else{
            if(password.count >= 6) {
                if(password == passwordNew){
                    let util = Util()
                    account.changePassword(passwordNew!)
                    let alertVC = util.alert(title: "비밀번호 변경", body: "비밀번호가 성공적으로 변경되었습니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
                        for controller in self.navigationController!.viewControllers{
                            guard let vc = controller as? PasswordSettingVC else { continue }
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    })
                    self.present(alertVC, animated: false)
                }
                else{
                    password = ""
                    let changeImage = UIImage(named: "pwLine")
                    let animation = ShakeAnimation()
                    self.view.layer.add(animation, forKey: "position")

                    lock.errorLabel.text = "비밀번호가 일치하지 않습니다."
                    lock.pwLine6.image = changeImage
                    lock.pwLine5.image = changeImage
                    lock.pwLine4.image = changeImage
                    lock.pwLine3.image = changeImage
                    lock.pwLine2.image = changeImage
                    lock.pwLine.image = changeImage
                }
            }
        }

    }

    func delPressed() {
        if(password.count > 0){
            lock.deleteLabel(password.count)
            password.removeLast()
        }
    }

    @objc func backPressed(_ sender: UIButton){
        for controller in self.navigationController!.viewControllers{
            guard let vc = controller as? PasswordSettingVC else { continue }
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
}
