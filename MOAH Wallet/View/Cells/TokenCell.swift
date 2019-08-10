//
// Created by 김경인 on 2019-08-10.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TokenCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds

    let tokenLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let logoImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let searchField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "토큰명/Contract 주소를 입력하세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(key: "light3")

        addSubview(logoImageView)
        addSubview(tokenLabel)

        selectionStyle = .none

        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true

        tokenLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tokenLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tokenLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: screenSize.width/20).isActive = true
        tokenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTokenValue(name: String, address: String, logo: UIImage?){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5

        let attrText = NSMutableAttributedString(string: name,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"), 
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n"+address,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 10, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey2")]))
        tokenLabel.attributedText = attrText
    }
}
