//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NetworkSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let reuseIdentifier = "networkCell"

    let screenSize = UIScreen.main.bounds

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("네트워크 추가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "네트워크 설정")
        self.transparentNavigationBar()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")
        view.addSubview(tableView)
        view.addSubview(addButton)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true

        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        cell.arrowImage.isHidden = true

        switch(indexPath.row){
        case 0:
            cell.menuLabel.text = "이더리움 메인넷"
            break
        case 1:
            cell.menuLabel.text = "Robsten 테스트넷"
            break
        case 2:
            cell.menuLabel.text = "Kovan 테스트넷"
            break
        case 3:
            cell.menuLabel.text = "Rinkeby 테스트넷"
            break
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    @objc func backPressed(_ sender: UIButton){
        let transition = RightTransition()
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false)
    }

    @objc func addPressed(_ sender: UIButton){

    }
}
