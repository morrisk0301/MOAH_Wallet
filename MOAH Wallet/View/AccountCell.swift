//
// Created by 김경인 on 2019-07-27.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AccountCell: UITableViewCell{

    let screenSize = UIScreen.main.bounds

    let accountLabel: UILabel = {
        let label = UILabel()

        label.text = "보조 계정"
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name:"NanumSquareRoundR", size: 15, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.applyShadow()

        return view
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .clear
        addContentView()
        addLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addContentView(){
        addSubview(content)

        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/30).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/30).isActive = true
    }

    private func addLabel(){
        addSubview(accountLabel)
        addSubview(addressLabel)

        accountLabel.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/100).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/5).isActive = true
        accountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addressLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/5).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}