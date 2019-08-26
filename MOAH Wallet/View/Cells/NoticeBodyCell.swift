//
// Created by 김경인 on 2019-08-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NoticeBodyCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds

    var bodyLabel: UILabel!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor(rgb: 0xEEEEEE)
    }

    override func prepareForReuse() {
        self.bodyLabel.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initBody(text: String) -> CGFloat {
        bodyLabel = UILabel(frame: CGRect(x: self.frame.width * 0.05, y: 0, width: self.frame.width * 0.9, height: CGFloat.greatestFiniteMagnitude))
        bodyLabel.text = "\n\n"+text
        bodyLabel.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        bodyLabel.textColor = UIColor(key: "darker")
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        bodyLabel.sizeToFit()
        addSubview(bodyLabel)

        return bodyLabel.frame.height + screenSize.height/20
    }
}
