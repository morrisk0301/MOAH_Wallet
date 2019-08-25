//
// Created by 김경인 on 2019-07-22.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

struct CellData{
    var title: String
    var titleOpened: Bool
    var question: [String]
    var answer: [String]
    var opened: [Bool]
    var height: [CGFloat]
}

class FAQVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let reuseIdentifier = "FAQCell"
    private let reuseIdentifierBody = "FAQBodyCell"

    private var tableData = [CellData]()

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
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "FAQ")
        self.transparentNavigationBar()

        view.backgroundColor = UIColor(key: "light3") 
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ExpandableCell.self, forCellReuseIdentifier: reuseIdentifierBody)

        setupLayout()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func loadData(){
        for index in 0..<4{
            var title: String!
            var question = [String]()
            var answer = [String]()
            var opened = [Bool]()
            var height = [CGFloat]()

            switch(index){
            case 0:
                title = "계정/지갑 관련 질문"
                for i in 0..<FAQData.account.allCases.count{
                    question.append(FAQData.account(rawValue: i)!.question)
                    answer.append(FAQData.account(rawValue: i)!.answer)
                    opened.append(false)
                    height.append(0)
                }
                break
            case 1:
                title = "토큰 관련 질문"
                for i in 0..<FAQData.token.allCases.count{
                    question.append(FAQData.token(rawValue: i)!.question)
                    answer.append(FAQData.token(rawValue: i)!.answer)
                    opened.append(false)
                    height.append(0)
                }
                break
            case 2:
                title = "암호화폐 전송/가스 비용 관련 질문"
                for i in 0..<FAQData.transfer.allCases.count{
                    question.append(FAQData.transfer(rawValue: i)!.question)
                    answer.append(FAQData.transfer(rawValue: i)!.answer)
                    opened.append(false)
                    height.append(0)
                }
                break
            case 3:
                title = "보안 관련 질문"
                for i in 0..<FAQData.security.allCases.count{
                    question.append(FAQData.security(rawValue: i)!.question)
                    answer.append(FAQData.security(rawValue: i)!.answer)
                    opened.append(false)
                    height.append(0)
                }
                break
            default:
                break
            }

            let cellData = CellData(title: title, titleOpened: false, question: question, answer: answer, opened: opened, height: height)
            self.tableData.append(cellData)
        }
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoticeCell
            cell.setNoticeValue(name: tableData[indexPath.section].title)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierBody, for: indexPath) as! ExpandableCell
            cell.backgroundColor = UIColor(rgb: 0xEEEEEE)
            cell.menuLabel.text = tableData[indexPath.section].question[indexPath.row-1]
            if(tableData[indexPath.section].opened[indexPath.row-1]){
                tableData[indexPath.section].height[indexPath.row-1] =
                        cell.addBody(body: tableData[indexPath.section].answer[indexPath.row-1])
            }

            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.tableData[section].titleOpened){
            return self.tableData[section].question.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return screenSize.height / 12
        }
        else if(self.tableData[indexPath.section].opened[indexPath.row-1]){
            return self.tableData[indexPath.section].height[indexPath.row-1]
        }
        return screenSize.height / 12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            if (self.tableData[indexPath.section].titleOpened) {
                self.tableData[indexPath.section].titleOpened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            } else {
                self.tableData[indexPath.section].titleOpened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .fade)
            }
        }
        else{
            if (self.tableData[indexPath.section].opened[indexPath.row-1]) {
                self.tableData[indexPath.section].opened[indexPath.row-1] = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .automatic)
            } else {
                self.tableData[indexPath.section].opened[indexPath.row-1] = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .automatic)
            }
        }
    }
}
