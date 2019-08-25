//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NoticeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let reuseIdentifier = "NoticeCell"
    private let reuseIdentifierBody = "NoticeBodyCell"

    let screenSize = UIScreen.main.bounds
    var notice: [CustomNotice] = [CustomNotice]()

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "공지사항")
        self.transparentNavigationBar()

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(NoticeBodyCell.self, forCellReuseIdentifier: reuseIdentifierBody)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadNotice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func loadNotice() {
        let httpRequest = HTTPRequest()
        httpRequest.getNotice(completion: { (notice) in
            self.notice = notice
            self.view.addSubview(self.tableView)
            self.setupLayout()
        })
    }

    private func setupLayout() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notice.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeCell
            cell.setNoticeValue(name: self.notice[indexPath.section].head, date: self.notice[indexPath.section].createdAt)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierBody, for: indexPath) as! NoticeBodyCell
            self.notice[indexPath.section].height = cell.initBody(text: self.notice[indexPath.section].body)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.notice[section].opened) {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return screenSize.height / 12
        } else {
            return self.notice[indexPath.section].height
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if (self.notice[indexPath.section].opened) {
                self.notice[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            } else {
                self.notice[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.hideSpinner()
    }
}
