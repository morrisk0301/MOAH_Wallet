//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MainRightMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private let reuseIdentifier = "RightMenuCell"

    let screenSize = UIScreen.main.bounds

    var delegate: MainControllerDelegate?

    var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        //tableView.separatorStyle = .none
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RightMenuCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = screenSize.height/15
        tableView.isScrollEnabled = false

        view.addSubview(tableView)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RightMenuCell
        cell.descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/3.5).isActive = true

        //cell.arrowImage.isHidden = true
        let menuOption = RightMenuOption(rawValue: indexPath.row)
        if(indexPath.row == 0){
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5

            let option = menuOption!

            let border = CALayer()
            border.backgroundColor = UIColor(key: "grey").cgColor
            border.frame = CGRect(x:0, y: cell.frame.height*0.9, width: screenSize.width, height: 0.5)

            let attrText = NSAttributedString(string: option.description,
                    attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 22, dynamic: true)!, 
                                 NSAttributedString.Key.paragraphStyle: style,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])

            cell.descriptionLabel.attributedText = attrText
            cell.descriptionLabel.numberOfLines = 0
            cell.layer.addSublayer(border)
            cell.arrowImage.isHidden = true

            return cell
        }
        else if(indexPath.row > 7){
            cell.arrowImage.isHidden = true
        }
        cell.descriptionLabel.text = menuOption?.description

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return screenSize.height/5
        }
        return screenSize.height/15
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = RightMenuOption(rawValue: indexPath.row)
        delegate?.rightSideMenuClicked(forMenuOption: menuOption)
    }

    private func setupLayout(){
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}