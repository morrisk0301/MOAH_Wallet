//
// Created by 김경인 on 2019-08-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift


class TransferAlertView: UIView {

    var amount: String!
    var address: String!
    var symbol: String!
    var gas: String!
    var total: String!
    var isToken = false
    var decimals: Int!

    let screenSize = UIScreen.main.bounds
    let util = Util()

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

    let amountTagLabel: UILabel = {
        let label = UILabel()

        label.text = "Amount".localized + ":"
        label.font = UIFont(name: "NanumSquareRoundR", size: 12, dynamic: true)
        label.textColor = UIColor(key: "grey")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasTagLabel: UILabel = {
        let label = UILabel()

        label.text = "Gas Fee".localized + ":"
        label.font = UIFont(name: "NanumSquareRoundR", size: 12, dynamic: true)
        label.textColor = UIColor(key: "grey")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let totalTagLabel: UILabel = {
        let label = UILabel()

        label.text = "Total".localized + ":"
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.textColor = UIColor(key: "grey")
        label.translatesAutoresizingMaskIntoConstraints = false

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

        label.text = "Do you wish to transfer?".localized
        label.font = UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    convenience init(info: TransferInfo, isToken: Bool){
        self.init()
        self.address = info.address
        self.decimals = info.decimals
        self.amount = util.trimZero(balance: Web3Utils.formatToEthereumUnits(info.amount, decimals: self.decimals))
        self.symbol = info.symbol
        self.gas = util.trimZero(balance: Web3Utils.formatToEthereumUnits(info.gas, decimals: 18))
        self.isToken = isToken
        if(isToken){
            self.total = self.amount
        }
        else{
            self.total = util.trimZero(balance: Web3Utils.formatToEthereumUnits(info.total, decimals: 18))
        }

        self.cutValue()
        setValue()

        setupLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(key: "light3")
    }

    private func setupLayout(){
        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(amountTagLabel)
        addSubview(gasTagLabel)
        addSubview(totalTagLabel)
        addSubview(amountLabel)
        addSubview(gasLabel)
        addSubview(totalLabel)
        addSubview(warningLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: screenSize.height/40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenSize.height/36).isActive = true

        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenSize.height/25).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true

        amountTagLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: screenSize.height/79).isActive = true
        amountTagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        amountTagLabel.widthAnchor.constraint(equalToConstant: screenSize.width/7).isActive = true
        amountTagLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        gasTagLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: screenSize.height/70).isActive = true
        gasTagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        gasTagLabel.widthAnchor.constraint(equalToConstant: screenSize.width/7).isActive = true
        gasTagLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        totalTagLabel.topAnchor.constraint(equalTo: gasLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
        totalTagLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenSize.width/15).isActive = true
        totalTagLabel.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        totalTagLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        amountLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: amountTagLabel.leadingAnchor, constant: screenSize.width/15).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        gasLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasLabel.leadingAnchor.constraint(equalTo: gasTagLabel.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasLabel.heightAnchor.constraint(equalToConstant: screenSize.height/40).isActive = true

        totalLabel.topAnchor.constraint(equalTo: gasLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
        totalLabel.leadingAnchor.constraint(equalTo: totalTagLabel.leadingAnchor, constant: screenSize.width/15).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenSize.width/15).isActive = true
        if(isToken){
            totalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/13).isActive = true
        }
        else{
            totalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true
        }

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
        let style = NSMutableParagraphStyle()
        style.alignment = .right

        let addressAttr = NSMutableAttributedString(string: "Transfer Address".localized + ": ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 12, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        addressAttr.append(NSAttributedString(string: self.address,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))

        addressLabel.attributedText = addressAttr

        let amountAttr = NSMutableAttributedString(string: self.amount + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"), 
                             NSAttributedString.Key.paragraphStyle: style])
        amountAttr.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        amountLabel.attributedText = amountAttr

        let gasAttr = NSMutableAttributedString(string: self.gas + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        gasAttr.append(NSAttributedString(string: "ETH",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        gasLabel.attributedText = gasAttr

        var totalAttr: NSMutableAttributedString!
        if(isToken){
            style.lineSpacing = 5
            var gas = self.gas!
            if(gas.count > 11){
                gas.removeLast(gas.count - 11)
                gas = gas + "..."
            }

            totalAttr = NSMutableAttributedString(string: self.total + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style])
            totalAttr.append(NSAttributedString(string: self.symbol,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
            totalAttr.append(NSAttributedString(string: "\n+" + gas + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style]))
            totalAttr.append(NSAttributedString(string: "ETH",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
        }
        else{
            totalAttr = NSMutableAttributedString(string: self.total + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style])
            totalAttr.append(NSAttributedString(string: self.symbol,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
        }

        totalLabel.attributedText = totalAttr
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented ")
    }
}
