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
        label.font = UIFont(name:"NanumSquareRoundR", size: 18, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.text = "0.00000 ETH"
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundB", size: 22, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor(key: "grey2")
        label.font = UIFont(name:"NanumSquareRoundR", size: 15, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let checkImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkMenu"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
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
        addCheck()
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
        addSubview(balanceLabel)
        addSubview(addressLabel)

        accountLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        accountLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor, constant: -screenSize.height/150).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/3).isActive = true

        balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/3).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true

        addressLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: screenSize.height/150).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/3).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func addCheck(){
        addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/10).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/20).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/15).isActive = true
    }

}