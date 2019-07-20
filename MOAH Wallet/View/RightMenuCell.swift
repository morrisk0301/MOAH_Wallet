//
// Created by 김경인 on 2019-07-21.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class RightMenuCell: UITableViewCell {

    let descriptionLabel: UILabel = {

        let label = UILabel()
        label.textColor = UIColor(key: "darker")
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Sample text"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(key: "lighter")
        selectionStyle = .none


        addSubview(descriptionLabel)
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
