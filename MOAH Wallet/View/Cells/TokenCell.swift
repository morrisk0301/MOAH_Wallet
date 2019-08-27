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
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let noSearchLabel: UILabel = {
        let label = UILabel()

        label.text = "Token search is only available\n\nin Ethereum mainnet.".localized
        label.font = UIFont(name:"NanumSquareRoundB", size: 15, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let checkImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkDark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(key: "light3")

        addSubview(logoImageView)
        addSubview(tokenLabel)

        selectionStyle = .none

        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/20).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: screenSize.width/12).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: screenSize.width/12).isActive = true

        tokenLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tokenLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tokenLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: screenSize.width/20).isActive = true
        tokenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.logoImageView.isHidden = false
        self.tokenLabel.isHidden = false
        self.noSearchLabel.isHidden = true
        self.isUserInteractionEnabled = true
        self.checkImage.isHidden = true
    }

    func setTokenValue(name: String, address: String, logo: Data){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6

        let attrText = NSMutableAttributedString(string: name,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"), 
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: "\n"+trimMiddle(address: address),
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRound", size: 11, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey2")]))
        tokenLabel.attributedText = attrText

        let logoImage = UIImage(data:logo,scale:1.0)
        self.logoImageView.image = logoImage
    }

    func setAsEther(){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5

        let attrText = NSMutableAttributedString(string: "Ethereum",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        tokenLabel.attributedText = attrText

        logoImageView.image = UIImage(named: "ether")
    }

    func noSearch(){
        logoImageView.isHidden = true
        tokenLabel.isHidden = true

        addSubview(noSearchLabel)
        noSearchLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        noSearchLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        noSearchLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noSearchLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        self.logoImageView.isHidden = true
    }

    func addCheckImage(){
        addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/30).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/22.5).isActive = true

        checkImage.isHidden = false
    }

    private func trimMiddle(address: String) -> String{
        var trim = address
        let range = address.index(address.startIndex, offsetBy: 20)..<address.index(address.startIndex, offsetBy: 30)
        trim.replaceSubrange(range, with: "...")

        return trim
    }
}
