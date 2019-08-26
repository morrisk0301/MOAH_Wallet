//
// Created by 김경인 on 2019-08-16.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift

class TXCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds
    var blankConstraint: NSLayoutConstraint!
    var nonBlankConstraint: NSLayoutConstraint!

    let txLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel()

        label.text = "승인중"
        label.textColor = UIColor(key: "grey2")
        label.layer.borderColor = UIColor(key: "grey2").cgColor
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1.0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override func prepareForReuse() {
        statusLabel.isHidden = false
        txLabel.text = ""
        txLabel.textAlignment = .left
        txLabel.isHidden = false
        blankConstraint.isActive = false
        backgroundColor = UIColor(key: "light3")

        for view in subviews{
            if view is MainTopView{
                view.removeFromSuperview()
            }
        }
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(key: "light3")

        addSubview(txLabel)
        addSubview(statusLabel)

        selectionStyle = .none

        txLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        txLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        txLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/20).isActive = true
        nonBlankConstraint = txLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -screenSize.width/20)
        blankConstraint = txLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/20)

        statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/20).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: screenSize.width/7).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTXValue(category: String, date: Date){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateModified = dateFormatter.string(from: date)

        let attrText = NSMutableAttributedString(string: dateModified,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 12, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey2"),
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n"+category,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))
        txLabel.attributedText = attrText
    }

    func setStatusLabel(status: String){
        switch(status){
        case "ok":
            statusLabel.text = "완료"
            statusLabel.textColor = UIColor(key: "regular")
            statusLabel.layer.borderColor = UIColor(key: "regular").cgColor
            break
        case "notYetProcessed":
            statusLabel.text = "승인중"
            statusLabel.textColor = UIColor(key: "grey2")
            statusLabel.layer.borderColor = UIColor(key: "grey2").cgColor
            break
        case "failed":
            statusLabel.text = "실패"
            statusLabel.textColor = UIColor.red
            statusLabel.layer.borderColor = UIColor.red.cgColor
            break
        default:
            statusLabel.text = "완료"
            statusLabel.textColor = UIColor(key: "regular")
            statusLabel.layer.borderColor = UIColor(key: "regular").cgColor
            break
        }
    }

    func nonTX(){
        txLabel.text = "Transaction history is empty".localized
        txLabel.font = UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)
        txLabel.textColor = UIColor(key: "darker")
        txLabel.textAlignment = .center

        nonBlankConstraint.isActive = false
        blankConstraint.isActive = true
        statusLabel.isHidden = true
    }

    func nonData(){
        txLabel.isHidden = true
        statusLabel.isHidden = true
    }
}
