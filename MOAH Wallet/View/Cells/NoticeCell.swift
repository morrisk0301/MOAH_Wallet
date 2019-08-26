//
// Created by 김경인 on 2019-08-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NoticeCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds

    let menuLabel: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let arrowImage: UIImageView = {

        let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "downMenuArrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = UIColor(key: "light3")

        setupLayout()
    }

    override func prepareForReuse() {
        backgroundColor = UIColor(key: "light3")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout(){
        addSubview(menuLabel)
        addSubview(arrowImage)

        menuLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/15).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -frame.width/15).isActive = true
        menuLabel.heightAnchor.constraint(equalToConstant: screenSize.height/12).isActive = true

        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: frame.width/35*1.5).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: (frame.width/35)).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/9).isActive = true
    }

    func setNoticeValue(name: String, date: Date){
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let newDate = dateFormatter.string(from: date)

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attrText = NSMutableAttributedString(string: name,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 17, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n"+newDate,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 13, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey2")]))
        menuLabel.attributedText = attrText
    }

    func setNoticeValue(name: String){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10

        let attrText = NSMutableAttributedString(string: name,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 15, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        menuLabel.attributedText = attrText
    }
}
