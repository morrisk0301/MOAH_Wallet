//
// Created by 김경인 on 2019-07-27.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell{

    let screenSize = UIScreen.main.bounds

    let menuLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let arrowImage: UIImageView = {

        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "rightMenuArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .clear

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout(){
        addSubview(menuLabel)
        addSubview(arrowImage)

        menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/15).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor).isActive = true
        menuLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: frame.width/35).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: (frame.width/35)*1.5).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/9).isActive = true
    }

}