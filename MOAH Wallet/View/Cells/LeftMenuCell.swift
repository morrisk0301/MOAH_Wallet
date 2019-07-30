//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds

    let descriptionLabel: UILabel = {

        let label = UILabel()
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRound", size: 17, dynamic: true)!
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)!
        label.textColor = UIColor(key: "grey2")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false


        return label
    }()

    let qrCodeImage: UIImageView = {
        let imageView = UIImageView()

        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let addressButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("Address", for: .normal)
        button.setTitleColor(UIColor(key: "darker"), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 15, dynamic: true)!
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(key: "grey2").cgColor
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let txFeeButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("TX Fee", for: .normal)
        button.setTitleColor(UIColor(key: "darker"), for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 15, dynamic: true)!
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(key: "grey2").cgColor
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(key: "light3")
        selectionStyle = .none
        qrCodeImage.applyShadow()

        addSubview(descriptionLabel)

        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -screenSize.width/10).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
