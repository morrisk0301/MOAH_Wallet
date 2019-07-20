//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MainLeftMenuVC: UIViewController {

    var tableView: UITableView!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    // MARK: - Handlers

    func configureTableView() {
        tableView = UITableView()
        //tableView.delegate = self
        //tableView.dataSource = self

        //tableView.register(<#T##cellClass: AnyClass?##Swift.AnyClass?#>, forCellReuseIdentifier: <#T##String##Swift.String#>)
        view.backgroundColor = UIColor(key: "lighter")
        tableView.separatorStyle = .none
        tableView.rowHeight = 80

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}