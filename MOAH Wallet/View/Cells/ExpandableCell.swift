//
// Created by 김경인 on 2019-08-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class ExpandableCell: UITableViewCell {

    let screenSize = UIScreen.main.bounds

    var bodyLabel: UILabel?

    let menuLabel: UILabel = {
        let label = UILabel()

        label.numberOfLines = 0
        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
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

        backgroundColor = UIColor(rgb: 0xEEEEEE)

        setupLayout()
    }

    override func prepareForReuse() {
        for view in subviews{
            if(view.tag == 1){
                view.removeFromSuperview()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout(){
        addSubview(menuLabel)
        addSubview(arrowImage)

        menuLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/24).isActive = true
        menuLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/15).isActive = true
        menuLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -frame.width/15).isActive = true
        menuLabel.heightAnchor.constraint(equalToConstant: screenSize.height/12).isActive = true

        arrowImage.centerYAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/24).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: frame.width/35*1.5).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: (frame.width/35)).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/9).isActive = true
    }

    func addBody(body: String) -> CGFloat {
        bodyLabel = UILabel(frame: CGRect(x: self.frame.width * 0.07, y: self.frame.height*0.3, width: self.frame.width * 0.8, height: CGFloat.greatestFiniteMagnitude))

        let style =  NSMutableParagraphStyle()
        style.lineSpacing = 5

        let attrText = NSMutableAttributedString(string: "\n\n\n\n"+body,
                attributes:[NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!, 
                           NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x777777),
                           NSAttributedString.Key.paragraphStyle: style])

        bodyLabel!.attributedText = attrText
        bodyLabel!.numberOfLines = 0
        bodyLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        bodyLabel!.sizeToFit()
        bodyLabel!.tag = 1
        addSubview(bodyLabel!)

        return bodyLabel!.frame.height + screenSize.height/30
    }
}
