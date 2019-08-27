//
// Created by 김경인 on 2019-07-27.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class NetworkCell: UITableViewCell{

    let screenSize = UIScreen.main.bounds

    let networkLabel: UILabel = {
        let label = UILabel()

        label.text = "Ethereum Mainnet".localized
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let urlLabel: UILabel = {
        let label = UILabel()

        label.text = "https://api.infura.io/v1/jsonrpc/mainnet"
        label.textColor = UIColor(key: "grey2")
        label.font = UIFont(name:"NanumSquareRoundR", size: 12, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let checkImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkMenu"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let content: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.applyShadow()

        return view
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .clear
        addContentView()
        addLabel()
        addCheck()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        networkLabel.textColor = UIColor(key: "darker")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addContentView(){
        addSubview(content)

        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/30).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/30).isActive = true
    }

    private func addLabel(){
        addSubview(networkLabel)
        addSubview(urlLabel)

        networkLabel.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/70).isActive = true
        networkLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        networkLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/2.5).isActive = true
        networkLabel.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true

        urlLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/10).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/2.5).isActive = true
        urlLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -screenSize.height/70).isActive = true
        urlLabel.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true
    }

    private func addCheck(){
        addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/9).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/30).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/22.5).isActive = true
    }

}