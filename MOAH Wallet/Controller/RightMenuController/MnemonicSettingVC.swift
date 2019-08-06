//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MnemonicSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private let reuseIdentifier = "mnemonicCell"

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.accountInstance
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
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "시드 구문 관리")
        self.transparentNavigationBar()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(tableView)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isFinished){
            self.verifiedButton.setTitle("인증완료", for: .normal)
            self.verifiedButton.setTitleColor(UIColor(key: "dark"), for: .normal)
            self.verifiedButton.layer.borderColor = UIColor(key: "dark").cgColor
            self.verifiedButton.layer.borderWidth = 1.0
            self.verifiedButton.backgroundColor = .clear


            let util = Util()
            let alertVC = util.alert(title: "시드 구문 인증 완료", body: "지금부터 MOAH Wallet의 모든 기능을 사용할 수 있습니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
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
            verifiedButton.setTitle("인증완료", for: .normal)
            verifiedButton.setTitleColor(UIColor(key: "dark"), for: .normal)
            verifiedButton.layer.borderColor = UIColor(key: "dark").cgColor
            verifiedButton.layer.borderWidth = 1.0
        }else{
            verifiedButton.setTitle("인증하기", for: .normal)
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
                cell.menuLabel.text = "시드 구문 조회"
                break
            case 1:
                setVerifyButton(cell: cell)
                cell.arrowImage.isHidden = true
                cell.menuLabel.text = "시드 구문 인증"
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
        return screenSize.height/10
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

    @objc func backPressed(_ sender: UIButton){
        let transition = RightTransition()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }
}
