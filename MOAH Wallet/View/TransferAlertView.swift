//
// Created by 김경인 on 2019-08-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit


class TransferAlertView: UIView {

    var amount: String!
    var address: String!
    var symbol: String!
    var gas: String!
    var total: String!

    let screenSize = UIScreen.main.bounds

    let titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "전송하시겠습니까?"
        label.font = UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    convenience init(info: TransferInfo){
        self.init()
        self.address = "0x0E32E68a20928826c5C805aB8b0509cAe3A90517"
        self.amount = info.amount
        self.symbol = info.symbol
        self.gas = info.gas
        self.total = info.total

        self.cutValue()
        setValue()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(key: "light3")
        setupLayout()
    }

    private func setupLayout(){
        addSubview(titleLabel)
        addSubview(amountLabel)
        addSubview(addressLabel)
        addSubview(gasLabel)
        addSubview(totalLabel)
        addSubview(warningLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenSize.height/36).isActive = true

        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenSize.height/30).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true

        amountLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        gasLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        gasLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        totalLabel.topAnchor.constraint(equalTo: gasLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
        totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        warningLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func cutValue(){
        if(amount.count > 18){
            amount.removeLast(amount.count - 18)
            amount = amount + "..."
        }

        if(gas.count > 18){
            gas.removeLast(gas.count - 18)
            gas = gas + "..."
        }

        if(total.count > 11){
            total.removeLast(total.count - 11)
            total = total + "..."
        }

    }

    private func setValue(){
        let addressAttr = NSMutableAttributedString(string: "전송 계정: ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        addressAttr.append(NSAttributedString(string: self.address,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))

        addressLabel.attributedText = addressAttr

        let amountAttr = NSMutableAttributedString(string: "전송 금액: ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        amountAttr.append(NSAttributedString(string: self.amount + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))
        amountAttr.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))

        amountLabel.attributedText = amountAttr

        let gasAttr = NSMutableAttributedString(string: "가스 비용: ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        gasAttr.append(NSAttributedString(string: self.gas + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))
        gasAttr.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))

        gasLabel.attributedText = gasAttr

        let totalAttr = NSMutableAttributedString(string: "총 비용: ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
        totalAttr.append(NSAttributedString(string: self.total + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "regular")]))
        totalAttr.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))

        totalLabel.attributedText = totalAttr
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}
