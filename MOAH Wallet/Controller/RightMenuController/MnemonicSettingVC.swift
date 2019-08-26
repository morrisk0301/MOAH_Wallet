//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{

    private let reuseIdentifier = "mnemonicCell"

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.shared
    var isFinished = false

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let verifiedButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 13, dynamic: true)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "Mnemonic Phrase".localized)
        self.transparentNavigationBar()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(tableView)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isFinished){
            self.verifiedButton.setTitle("Verified".localized, for: .normal)
            self.verifiedButton.setTitleColor(UIColor(key: "dark"), for: .normal)
            self.verifiedButton.layer.borderColor = UIColor(key: "dark").cgColor
            self.verifiedButton.layer.borderWidth = 1.0
            self.verifiedButton.backgroundColor = .clear


            let util = Util()
            let alertVC = util.alert(title: "Mnemonic Verified".localized, body: "All features of MOAH Wallet has been enabled.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in
                self.reloadMainContainerVC()
                self.isFinished = false
            })
            self.present(alertVC, animated: false)
        }
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setVerifyButton(cell: UITableViewCell){
        let isVerified = account.getIsVerified()

        if(isVerified){
            verifiedButton.setTitle("Verified".localized, for: .normal)
            verifiedButton.setTitleColor(UIColor(key: "dark"), for: .normal)
            verifiedButton.layer.borderColor = UIColor(key: "dark").cgColor
            verifiedButton.layer.borderWidth = 1.0
        }else{
            verifiedButton.setTitle("Verify".localized, for: .normal)
            verifiedButton.setTitleColor(UIColor.white, for: .normal)
            verifiedButton.backgroundColor = UIColor(key: "regular")
        }

        cell.addSubview(verifiedButton)

        verifiedButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        verifiedButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -screenSize.width/10).isActive = true
        verifiedButton.heightAnchor.constraint(equalToConstant: screenSize.width/15).isActive = true
        verifiedButton.widthAnchor.constraint(equalToConstant: screenSize.width/5.5).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell

        switch (indexPath.row){
            case 0:
                cell.menuLabel.text = "View Mnemonic Phrase".localized
                break
            case 1:
                setVerifyButton(cell: cell)
                cell.arrowImage.isHidden = true
                cell.menuLabel.text = "Verify Mnemonic Phrase".localized
                break
            default:
                break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
        case 0:
            let controller = PasswordCheckVC()
            controller.toView = "mnemonic"
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
            let isVerified = account.getIsVerified()
            if(!isVerified){
                let controller = MnemonicVerificationVC()
                controller.isSetting = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
            break
        default:
            break
        }
    }
}
