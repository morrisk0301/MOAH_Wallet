//
// Created by 김경인 on 2019-07-27.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AccountCell: UITableViewCell{

    let screenSize = UIScreen.main.bounds

    var symbol: String!

    let accountLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor(key: "grey2")
        label.font = UIFont(name:"NanumSquareRoundR", size: 13, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let privateKeyLabel: UILabel = {
        let label = UILabel()

        label.text = "External".localized
        label.textColor = UIColor(key: "dark")
        label.font = UIFont(name:"NanumSquareRoundB", size: 10, dynamic: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor(key: "dark").cgColor
        label.layer.borderWidth = 1.0
        label.translatesAutoresizingMaskIntoConstraints = false

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

    override func prepareForReuse() {
        accountLabel.textColor = UIColor(key: "darker")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSymbol(symbol: String){
        self.balanceLabel.text = "0.0000 "+symbol
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
        addSubview(privateKeyLabel)
        addSubview(balanceLabel)
        addSubview(addressLabel)

        accountLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        accountLabel.bottomAnchor.constraint(equalTo: balanceLabel.topAnchor).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/3).isActive = true

        privateKeyLabel.centerYAnchor.constraint(equalTo: accountLabel.centerYAnchor).isActive = true
        privateKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/12).isActive = true
        privateKeyLabel.widthAnchor.constraint(equalToConstant: screenSize.width/6).isActive = true
        privateKeyLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/5).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        addressLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/3).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func addCheck(){
        addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/9).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/20).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/15).isActive = true
    }

}