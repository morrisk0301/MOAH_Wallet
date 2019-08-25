//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import UserNotifications

class PasswordSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let reuseIdentifier = "networkCell"

    let screenSize = UIScreen.main.bounds
    let userDefaults = UserDefaults.standard
    let autoContext = LAContext()
    let util = Util()
    var useBiometrics: Bool!
    var useLock: Bool!
    var usePush: Bool!

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let lockSwitch: UISwitch = {

        let lockSwitch = UISwitch()
        lockSwitch.onTintColor = UIColor(key: "regular")
        lockSwitch.translatesAutoresizingMaskIntoConstraints = false
        lockSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
        lockSwitch.tag = 0

        return lockSwitch
    }()


    let bioSwitch: UISwitch = {

        let bioSwitch = UISwitch()
        bioSwitch.onTintColor = UIColor(key: "regular")
        bioSwitch.translatesAutoresizingMaskIntoConstraints = false
        bioSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
        bioSwitch.tag = 1

        return bioSwitch
    }()

    let pushSwitch: UISwitch = {

        let pushSwitch = UISwitch()
        pushSwitch.onTintColor = UIColor(key: "regular")
        pushSwitch.translatesAutoresizingMaskIntoConstraints = false
        pushSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
        pushSwitch.tag = 2

        return pushSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "보안 및 알림 설정")
        self.transparentNavigationBar()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        var navCounter = 0
        for controller in self.navigationController!.viewControllers{
            if(controller is PasswordCheckVC){
                self.navigationController?.viewControllers.remove(at: navCounter)
            }
            navCounter += 1
        }

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        useBiometrics = userDefaults.bool(forKey: "useBiometrics")
        useLock = userDefaults.bool(forKey: "useLock")
        usePush = userDefaults.bool(forKey: "alarm")
        bioSwitch.isOn = useBiometrics
        lockSwitch.isOn = useLock
        pushSwitch.isOn = usePush

        view.addSubview(tableView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func addSwitch(cell: UITableViewCell, uiSwitch: UISwitch){
        cell.addSubview(uiSwitch)
        uiSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -screenSize.width/10).isActive = true
        uiSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        uiSwitch.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        uiSwitch.widthAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true
    }

    private func authBiometrics(){
        if(autoContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)){
            let alertVC = util.alert(title: "생체인식 기능 사용", body: "빠른 앱 실행을 위해\n생체인식 기능을 사용하시겠습니까?", buttonTitle: "사용하기", buttonNum: 2){(next) in
                if(next){
                    self.autoContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MOAH Wallet 생체인식"){(success, error) in
                        DispatchQueue.main.async {
                            if (success) {
                                self.userDefaults.set(true, forKey: "useBiometrics")
                                self.useBiometrics = true
                            }
                            else{
                                self.bioSwitch.isOn = false
                            }
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.bioSwitch.isOn = false
                    }
                }
            }
            self.present(alertVC, animated: false)
        }else{
            DispatchQueue.main.async {
                let alertVC = self.util.alert(title: "생체인식 기능 오류", 
                        body: "생체인식 기능을 사용할 수 없습니다.\n단말기 -> 설정에서 MOAH Wallet의 생체인식 권한을 허용해주세요.", 
                        buttonTitle: "확인", buttonNum: 1, completion: { _ in
                    self.bioSwitch.isOn = false
                })
                self.present(alertVC, animated: false)
            }
        }
    }

    private func useAlarm(){
        let alertVC = util.alert(title: "푸시 알림 설정", body: "MOAH Wallet의 푸시 알림을 원하시면 동의 버튼을 눌러주세요.", buttonTitle: "동의", buttonNum: 2, completion: {(agree) in
            if(agree){
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .notDetermined {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(success, error) in
                            if(success){
                                self.userDefaults.set(true, forKey: "alarm")
                                self.usePush = true
                            }
                            else{
                                self.userDefaults.set(false, forKey: "alarm")
                                self.pushSwitch.isOn = false
                            }
                        })
                    } else if settings.authorizationStatus == .denied {
                        DispatchQueue.main.async {
                            let alertVC = self.util.alert(title: "푸시 알림 오류",
                                    body: "푸시알림 기능을 사용할 수 없습니다.\n단말기 -> 설정에서 MOAH Wallet의 푸시알림 권한을 허용해주세요.",
                                    buttonTitle: "확인", buttonNum: 1, completion: { _ in
                                self.userDefaults.set(false, forKey: "alarm")
                                self.pushSwitch.isOn = false
                            })
                            self.present(alertVC, animated: false)
                        }
                    } else if settings.authorizationStatus == .authorized {
                        self.userDefaults.set(true, forKey: "alarm")
                        self.usePush = true
                    }
                }
            }
            else{
                self.userDefaults.set(false, forKey: "alarm")
                self.pushSwitch.isOn = false
            }
        })
        self.present(alertVC, animated: false)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell

        switch(indexPath.section){
            case 0:
                cell.menuLabel.text = "앱 잠금"
                cell.arrowImage.isHidden = true
                addSwitch(cell: cell, uiSwitch: lockSwitch)
                break
            case 1:
                cell.menuLabel.text = "생체인식 기능 사용"
                cell.arrowImage.isHidden = true
                addSwitch(cell: cell, uiSwitch: bioSwitch)
                break
            case 2:
                cell.menuLabel.text = "푸시 알림 설정"
                cell.arrowImage.isHidden = true
                addSwitch(cell: cell, uiSwitch: pushSwitch)
                break
            case 3:
                cell.menuLabel.text = "비밀번호 변경"
                break
            default:
                break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 3){
            let controller = PasswordChangeVC()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @objc func switchPressed(_ sender: UISwitch){
        if(sender.tag == 0){
            useLock = !useLock
            userDefaults.set(useLock, forKey: "useLock")
        }
        else if (sender.tag == 1){
            if(!useBiometrics){
                authBiometrics()
            }else{
                useBiometrics = false
                userDefaults.set(false, forKey: "useBiometrics")
            }
        }
        else if (sender.tag == 2){
            if(!usePush){
                useAlarm()
            }else{
                usePush = false
                userDefaults.set(false, forKey: "alarm")
            }
        }
    }
}
