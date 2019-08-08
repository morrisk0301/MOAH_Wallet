//
// Created by 김경인 on 2019-08-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class AmountCell: UICollectionViewCell {

    let digitsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(digitsLabel)
        digitsLabel.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}
