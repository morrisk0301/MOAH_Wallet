//
// Created by 김경인 on 2019-08-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NormalAlertView: UIView {

    let screenSize = UIScreen.main.bounds

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)

        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = UIColor(red: 130, green: 130, blue: 130)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        label.numberOfLines = 0

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(key: "light3")
        setupLayout()
    }

    private func setupLayout(){
        addSubview(titleLabel)
        addSubview(bodyLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenSize.height/36).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/12).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/12).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}
