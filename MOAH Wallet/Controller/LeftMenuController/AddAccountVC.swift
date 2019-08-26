//
// Created by 김경인 on 2019-07-28.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AddAccountVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let reuseIdentifier = "MenuCell"

    let screenSize = UIScreen.main.bounds

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "Add Account".localized)

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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell

        if(indexPath.row == 0){
            cell.menuLabel.text = "Create Account".localized
        }
        else{
            cell.menuLabel.text = "Get Account with Private Key".localized;
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
        var controller: UIViewController!

        if(indexPath.row == 0){
            controller = CreateAccountVC()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            controller = GetAccountVC()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
