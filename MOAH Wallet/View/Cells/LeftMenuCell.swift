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
        label.font = UIFont(name:"NanumSquareRound", size: 15, dynamic: true)!
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressText: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))

        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)!
        textView.textColor = UIColor(key: "darker")
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false


        return textView
    }()

    let qrCodeImage: UIImageView = {
        let imageView = UIImageView()

        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let arrowImage: UIImageView = {

        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "rightMenuArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(key: "light3")
        selectionStyle = .none
        qrCodeImage.applyShadow()

        addSubview(descriptionLabel)
        //addSubview(arrowImage)

        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/9).isActive = true

        //arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //arrowImage.widthAnchor.constraint(equalToConstant: frame.width/35).isActive = true
        //arrowImage.heightAnchor.constraint(equalToConstant: (frame.width/35)*1.5).isActive = true
        //arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/9).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
