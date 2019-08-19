//
// Created by 김경인 on 2019-08-19.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class MainTopView: UIView {

    let screenSize = UIScreen.main.bounds

    var delegate: CheckVerifiedDelegate?

    let tokenView: MainTokenView = {
        let tokenView = MainTokenView()
        tokenView.translatesAutoresizingMaskIntoConstraints = false

        return tokenView
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 40, dynamic: true)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let transferButton: TransparentButton = {
        let button = TransparentButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(transferPressed(_:)), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }

    private func setupLayout(){
        addSubview(tokenView)
        addSubview(balanceLabel)
        addSubview(transferButton)
        //addSubview(txLabel)

        tokenView.centerYAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/20).isActive = true
        tokenView.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true
        tokenView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/5).isActive = true
        tokenView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/5).isActive = true

        balanceLabel.topAnchor.constraint(equalTo: tokenView.bottomAnchor).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenSize.height/6.5).isActive = true
        balanceLabel.centerXAnchor.constraint(equalTo: tokenView.centerXAnchor).isActive = true
        balanceLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        transferButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor).isActive = true
        transferButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        transferButton.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true
        transferButton.widthAnchor.constraint(equalToConstant: screenSize.width/2.5).isActive = true
    }

    @objc private func transferPressed(_ sender: UIButton){
        self.delegate?.checkClicked()
    }
}
