//
// Created by 김경인 on 2019-07-24.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class MainTokenView: UIView {

    let screenSize = UIScreen.main.bounds
    var delegate: MainControllerDelegate?

    let tokenImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ethLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let tokenName: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    let buttonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "downArrow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewClicked(_:)))
        addGestureRecognizer(tap)

        setupLayout()
    }

    func setTokenString(tokenString: String){
        let attachImage = NSTextAttachment()
        attachImage.image = UIImage(named: "downArrow")
        attachImage.bounds = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width/35)*1.5, height: (UIScreen.main.bounds.width/35))

        let attrText = NSMutableAttributedString(string: tokenString+"  " , attributes: [
            NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ])
        attrText.append(NSAttributedString(attachment: attachImage))

        tokenName.attributedText = attrText
    }

    func setupLayout(){
        addSubview(tokenName)

        tokenName.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tokenName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tokenName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tokenName.heightAnchor.constraint(equalToConstant: screenSize.width/20).isActive = true
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }

    @objc func viewClicked(_ sender: UITapGestureRecognizer) {
        AudioServicesPlaySystemSound(1519)
        delegate?.tokenViewClicked()
    }
}
