//
// Created by 김경인 on 2019-08-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AmountCell: UICollectionViewCell {

    let digitsLabel = UILabel()

    let addLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 12, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.layer.cornerRadius = 5
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor(key: "darker").cgColor
        label.layer.borderWidth = 0.5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(addLabel)
        addLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        addLabel.widthAnchor.constraint(equalToConstant: frame.width*0.9).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}
