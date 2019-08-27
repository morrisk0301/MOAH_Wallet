//
// Created by 김경인 on 2019-08-16.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift
import BigInt

class TXDetailVC: UIViewController{

    let screenSize = UIScreen.main.bounds
    let util = Util()

    var txInfo: TXInfo!
    var gasPrice: BigUInt?
    var gasLimit: BigUInt?
    var gasUsed: BigUInt?
    var total: BigUInt?
    var infura = false
    var network: CustomWeb3Network?
    var symbol: String!

    let hashLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let dateTag: UILabel = {
        let label = UILabel()

        label.text = "TX Time".localized + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let dateLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let statusTag: UILabel = {
        let label = UILabel()

        label.text = "TX Status".localized + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let statusLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let txLabel: UILabel = {
        let label = UILabel()

        label.text = "Transaction2".localized
        label.textAlignment = .center
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let amountTag: UILabel = {
        let label = UILabel()

        label.text = "Amount".localized + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let amountLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasPriceTag: UILabel = {
        let label = UILabel()

        label.text = "Gas Price".localized+": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasPriceLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasLimitTag: UILabel = {
        let label = UILabel()

        label.text = "Gas Limit".localized+": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasLimitLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasUsedTag: UILabel = {
        let label = UILabel()

        label.text = "Gas Used".localized + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasUsedLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasFinalTag: UILabel = {
        let label = UILabel()

        label.text = "Gas Fee".localized + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let gasFinalLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let totalTag: UILabel = {
        let label = UILabel()

        label.text = "Total" + ": "
        label.textColor = UIColor(key: "grey")
        label.font = UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let totalLabel: UILabel = {

        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nextButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("View in Etherscan".localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "Transaction Detail".localized)

        view.backgroundColor = UIColor(key: "light3")

        let symbol = txInfo.value(forKey: "symbol") as! String
        self.symbol = symbol
    }

    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadTxData(completion: {
            DispatchQueue.main.async{
                self.setupLayout()
                self.setValue()
                self.hideSpinner()
            }
        })
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:0, y: -screenSize.height/40, width: txLabel.frame.width, height: 1)
        txLabel.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        view.addSubview(hashLabel)
        view.addSubview(toLabel)
        view.addSubview(dateTag)
        view.addSubview(dateLabel)
        view.addSubview(statusTag)
        view.addSubview(statusLabel)
        view.addSubview(txLabel)
        view.addSubview(amountTag)
        view.addSubview(amountLabel)
        view.addSubview(gasPriceTag)
        view.addSubview(gasPriceLabel)
        view.addSubview(gasLimitTag)
        view.addSubview(gasLimitLabel)
        view.addSubview(gasUsedTag)
        view.addSubview(gasUsedLabel)
        view.addSubview(gasFinalTag)
        view.addSubview(gasFinalLabel)
        view.addSubview(totalTag)
        view.addSubview(totalLabel)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hashPressed(_:)))
        hashLabel.addGestureRecognizer(tap)
        hashLabel.isUserInteractionEnabled = true

        hashLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/40).isActive = true
        hashLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        hashLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        hashLabel.heightAnchor.constraint(equalToConstant: screenSize.height/14).isActive = true

        toLabel.topAnchor.constraint(equalTo: hashLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        toLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        toLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        toLabel.heightAnchor.constraint(equalToConstant: screenSize.height/14).isActive = true

        dateTag.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        dateTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        dateTag.widthAnchor.constraint(equalToConstant: screenSize.width/3).isActive = true
        dateTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        dateLabel.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: dateTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        statusTag.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        statusTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        statusTag.widthAnchor.constraint(equalToConstant: screenSize.width/2.5).isActive = true
        statusTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        statusLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: screenSize.height/80).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: statusTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        txLabel.topAnchor.constraint(equalTo: statusTag.bottomAnchor, constant: screenSize.height/20).isActive = true
        txLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        txLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        txLabel.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true

        amountTag.topAnchor.constraint(equalTo: txLabel.bottomAnchor, constant: screenSize.height/40).isActive = true
        amountTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        amountTag.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        amountTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        amountLabel.topAnchor.constraint(equalTo: txLabel.bottomAnchor, constant: screenSize.height/40).isActive = true
        amountLabel.leadingAnchor.constraint(equalTo: amountTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasPriceTag.topAnchor.constraint(equalTo: amountTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasPriceTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasPriceTag.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        gasPriceTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasPriceLabel.topAnchor.constraint(equalTo: amountTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasPriceLabel.leadingAnchor.constraint(equalTo: gasPriceTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasPriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasPriceLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasLimitTag.topAnchor.constraint(equalTo: gasPriceTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasLimitTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasLimitTag.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        gasLimitTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasLimitLabel.topAnchor.constraint(equalTo: gasPriceTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasLimitLabel.leadingAnchor.constraint(equalTo: gasLimitTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasLimitLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasUsedTag.topAnchor.constraint(equalTo: gasLimitTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasUsedTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasUsedTag.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        gasUsedTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasUsedLabel.topAnchor.constraint(equalTo: gasLimitTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasUsedLabel.leadingAnchor.constraint(equalTo: gasUsedTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasUsedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasUsedLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasFinalTag.topAnchor.constraint(equalTo: gasUsedTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasFinalTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasFinalTag.widthAnchor.constraint(equalToConstant: screenSize.width/4).isActive = true
        gasFinalTag.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        gasFinalLabel.topAnchor.constraint(equalTo: gasUsedTag.bottomAnchor, constant: screenSize.height/80).isActive = true
        gasFinalLabel.leadingAnchor.constraint(equalTo: gasFinalTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        gasFinalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        gasFinalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/30).isActive = true

        totalTag.topAnchor.constraint(equalTo: gasFinalTag.bottomAnchor, constant: screenSize.height/40).isActive = true
        totalTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        totalTag.widthAnchor.constraint(equalToConstant: screenSize.width/5).isActive = true
        totalTag.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true

        totalLabel.topAnchor.constraint(equalTo: gasFinalLabel.bottomAnchor, constant: screenSize.height/40).isActive = true
        totalLabel.leadingAnchor.constraint(equalTo: totalTag.leadingAnchor, constant: screenSize.width/15).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        if(self.symbol == "ETH"){
            totalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        }
        else{
            totalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/10).isActive = true
        }

        if(infura){
            self.addNextButton()
        }
    }

    private func addNextButton(){
        view.addSubview(nextButton)

        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    private func loadTxData(completion: @escaping () -> ()){
        let web3: CustomWeb3 = CustomWeb3.shared
        network = web3.network
        DispatchQueue.global(qos: .userInteractive).sync{
            let hash = self.txInfo.value(forKey: "txHash") as! String
            if (network!.name == "mainnet" || network!.name == "ropsten" ||  network!.name == "rinkeby") {
                self.infura = true
            }
            if(hash == ""){
                completion()
            }
            else{
                let txReceipt = web3.getTXReceipt(hash: hash)
                self.gasUsed = txReceipt?.gasUsed
                completion()
            }
        }
    }

    private func cutValue(text: String, cutIndex: Int) -> String {
        var modified = text
        if(modified.count > cutIndex){
            modified.removeLast(modified.count - cutIndex)
            modified = modified + "..."
        }
        return modified
    }

    private func setValue(){
        let hash = txInfo.value(forKey: "txHash") as! String
        let to = txInfo.value(forKey: "to") as! String
        let date = txInfo.value(forKey: "date") as! Date
        let amount = txInfo.value(forKey: "amount") as! String
        let gasPrice = txInfo.value(forKey: "gasPrice") as! String
        let gasLimit = txInfo.value(forKey: "gasLimit") as! String

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateModified = dateFormatter.string(from: date)

        let attachImage = NSTextAttachment()
        attachImage.image = UIImage(named: "copy")
        attachImage.bounds = CGRect(x: 0, y: -1, width: (UIScreen.main.bounds.width/30), height: (UIScreen.main.bounds.width/28))

        let style = NSMutableParagraphStyle()
        style.alignment = .right

        let hashAttr = NSMutableAttributedString(string: "TX Hash".localized + ": ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        hashAttr.append(NSAttributedString(string: hash+"  ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))
        if(hash.count != 0){
            hashAttr.append(NSAttributedString(attachment: attachImage))
        }

        hashLabel.attributedText = hashAttr


        let toAttr = NSMutableAttributedString(string: "Transfer Address".localized + ": ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")])
        toAttr.append(NSAttributedString(string: to,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "grey")]))

        toLabel.attributedText = toAttr

        let dateAttr = NSMutableAttributedString(string: dateModified,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])

        dateLabel.attributedText = dateAttr


        setStatusLabel()

        let amountAttr = setAttr(value: amount, cutIndex: 18, symbol: self.symbol)
        let gasPriceAttr = setAttr(value: gasPrice, cutIndex: 18, symbol: "GWei")
        let gasLimitAttr = setAttr(value: gasLimit, cutIndex: 18, symbol: "")
        amountLabel.attributedText = amountAttr
        gasPriceLabel.attributedText = gasPriceAttr
        gasLimitLabel.attributedText = gasLimitAttr

        if(self.gasUsed == nil){ return }

        let gasUsedString = util.trimZero(balance: Web3Utils.formatToEthereumUnits(self.gasUsed!, toUnits: .wei)!)
        let gasUsedAttr = setAttr(value: gasUsedString, cutIndex: 18, symbol: "")
        let gasFinal: BigUInt = self.gasUsed! * Web3Utils.parseToBigUInt(gasPrice, units: .Gwei)!
        let gasFinalString = util.trimZero(balance: Web3Utils.formatToEthereumUnits(gasFinal, decimals: 18)!)
        let gasFinalAttr = setAttr(value: gasFinalString, cutIndex: 18, symbol: "ETH")
        gasUsedLabel.attributedText = gasUsedAttr
        gasFinalLabel.attributedText = gasFinalAttr

        var totalAttr: NSMutableAttributedString!
        if(self.symbol != "ETH"){
            style.lineSpacing = 5

            let gasString = util.trimZero(balance: Web3Utils.formatToEthereumUnits(gasFinal, decimals: 18)!)
            let gasCut = cutValue(text: gasString, cutIndex: 15)

            let totalString = amount
            let totalCut = cutValue(text: totalString, cutIndex: 15)

            totalAttr = NSMutableAttributedString(string: totalCut + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style])
            totalAttr.append(NSAttributedString(string: self.symbol,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
            totalAttr.append(NSAttributedString(string: "\n+" + gasCut + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style]))
            totalAttr.append(NSAttributedString(string: "ETH",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
        }
        else{
            let total = Web3Utils.parseToBigUInt(amount, decimals: 18)! + gasFinal
            let totalString = util.trimZero(balance: Web3Utils.formatToEthereumUnits(total, decimals: 18)!)
            let totalCut = cutValue(text: totalString, cutIndex: 15)

            totalAttr = NSMutableAttributedString(string: totalCut + " ",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style])
            totalAttr.append(NSAttributedString(string: "ETH",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 20, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                                 NSAttributedString.Key.paragraphStyle: style]))
        }

        totalLabel.attributedText = totalAttr
    }

    private func setAttr(value: String, cutIndex: Int, symbol: String) -> NSMutableAttributedString? {
        let style = NSMutableParagraphStyle()
        style.alignment = .right

        let valueFinal = cutValue(text: value, cutIndex: cutIndex)

        let attrText = NSMutableAttributedString(string: valueFinal + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style])
        attrText.append(NSAttributedString(string: symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundR", size: 16, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker"),
                             NSAttributedString.Key.paragraphStyle: style]))

        return attrText
    }

    private func setStatusLabel(){
        let style = NSMutableParagraphStyle()
        style.alignment = .right

        switch(txInfo.status){
        case "ok":
            let attrText = NSMutableAttributedString(string: "Success2".localized,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "regular"),
                                 NSAttributedString.Key.paragraphStyle: style])
            statusLabel.attributedText = attrText
            break
        case "notYetProcessed":
            let attrText = NSMutableAttributedString(string: "Pending2".localized,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "grey"),
                                 NSAttributedString.Key.paragraphStyle: style])
            attrText.append(NSAttributedString(string: "(" + "TX info will be updated shortly.".localized + ")",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 10, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "grey2"),
                                 NSAttributedString.Key.paragraphStyle: style]))
            statusLabel.attributedText = attrText
            break
        case "failed":
            let attrText = NSMutableAttributedString(string: "Failed2".localized,
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.red,
                                 NSAttributedString.Key.paragraphStyle: style])
            attrText.append(NSAttributedString(string: "("+self.txInfo.error!+")",
                    attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 10, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.red,
                                 NSAttributedString.Key.paragraphStyle: style]))
            statusLabel.attributedText = attrText
            break
        default:
            break
        }
    }

    @objc private func nextPressed(_ sender: UIButton){
        var url: URL!
        let txHash = self.txInfo.value(forKey: "txHash") as! String
        if(network!.name == "mainnet"){
            url = URL(string: "https://etherscan.io/tx/"+txHash)
        }
        else{
            url = URL(string: "https://"+network!.name+".etherscan.io/tx/"+txHash)
        }
        UIApplication.shared.open(url)
    }

    @objc private func hashPressed(_ sender: UITapGestureRecognizer){
        let util = Util()
        let hash = self.txInfo.value(forKey: "txHash") as! String
        if(hash.count == 0){
            return
        }
        UIPasteboard.general.string = hash
        let alertVC = util.alert(title: "Copy TX Hash".localized, body: "TX Hash has been copied to clipboard.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in})
        self.present(alertVC, animated: false)
    }
}
