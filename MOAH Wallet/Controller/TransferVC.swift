//
// Created by 김경인 on 2019-08-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import web3swift

class TransferVC: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, QRCodeReadDelegate {

    private let reuseIdentifier = "AmountCell"

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.shared
    let util = Util()
    var amountVerified = false
    var balanceString: String!
    var balance: BigUInt!
    var symbol: String!
    var decimals: Int!

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  전송 금액"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name: "NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  전송 계정 주소"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let amountField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "전송할 금액을 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name: "NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.tag = 0
        textField.addTarget(self, action: #selector(amountInput(_:)), for: .editingChanged)

        return textField
    }()

    let amountCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(key: "light3")
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
    }()

    let errorLabel: UILabel = {
        let label = UILabel()

        label.isHidden = true
        label.font = UIFont(name: "NanumSquareRoundR", size: 14, dynamic: true)
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "전송할 계정 주소를 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name: "NanumSquareRoundR", size: 16, dynamic: true)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .asciiCapable
        textField.tag = 1

        return textField
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = "암호화폐 특성상, 전송 후 어떠한 경우에도 취소가 불가능합니다.\n\n지갑 주소와 전송 금액을 신중하게 입력해주세요."
        label.font = UIFont(name: "NanumSquareRoundR", size: 15, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("전송하기", for: .normal)
        button.backgroundColor = UIColor(key: "light")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)
        button.isEnabled = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "암호화폐 전송")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")

        amountCV.delegate = self
        amountCV.dataSource = self
        amountCV.register(AmountCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        addressField.delegate = self

        view.addSubview(balanceLabel)
        view.addSubview(amountLabel)
        view.addSubview(amountField)
        view.addSubview(amountCV)
        view.addSubview(errorLabel)
        view.addSubview(addressLabel)
        view.addSubview(addressField)
        view.addSubview(warningLabel)
        view.addSubview(confirmButton)

        setRightView()
        setupLayout()
        setBalanceLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x: 0, y: addressField.frame.height + screenSize.height / 20, width: addressField.frame.width, height: 1)
        addressField.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setBalanceLabel(){

        var balanceString = self.balanceString!

        if(balanceString.count > 11){
            balanceString.removeLast(balanceString.count - 11)
            balanceString += "..."
        }

        let attrText = NSMutableAttributedString(string: balanceString + " ",
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 30, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "regular")])
        attrText.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundB", size: 30, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))

        balanceLabel.attributedText = attrText
    }

    private func setupLayout() {
        balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height / 30).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width / 15).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width / 15).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenSize.width / 10).isActive = true

        amountLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: screenSize.height / 30).isActive = true
        amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 25).isActive = true
        amountLabel.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9).isActive = true

        amountField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor).isActive = true
        amountField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountField.heightAnchor.constraint(equalToConstant: screenSize.height / 15).isActive = true
        amountField.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9).isActive = true

        amountCV.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: screenSize.height / 40).isActive = true
        amountCV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountCV.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9).isActive = true
        amountCV.heightAnchor.constraint(equalToConstant: screenSize.height / 20).isActive = true

        errorLabel.topAnchor.constraint(equalTo: amountCV.bottomAnchor).isActive = true
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: screenSize.width * 0.85).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 40).isActive = true

        addressLabel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: screenSize.height / 40).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 25).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9).isActive = true

        addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor).isActive = true
        addressField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: screenSize.height / 15).isActive = true
        addressField.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9).isActive = true

        warningLabel.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: screenSize.height / 12).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width / 15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width / 15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height / 10).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height / 20).isActive = true
    }

    private func setRightView(){
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width*0.15, height: screenSize.height/20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width*0.15, height: screenSize.height/20))
        label.text = self.symbol
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)
        label.textAlignment = .center
        rightView.addSubview(label)

        amountField.rightView = rightView
        amountField.rightViewMode = .always

        let tap = UITapGestureRecognizer(target: self, action: #selector(qrPressed(_:)))
        let rightView2 = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.height/20, height: screenSize.height/20))
        let imageView = UIImageView(frame: CGRect(x:screenSize.height/160 , y: screenSize.height/80, width: screenSize.height/40, height: screenSize.height/40))
        imageView.image = UIImage(named: "qr")
        rightView2.addSubview(imageView)
        rightView2.addGestureRecognizer(tap)

        addressField.rightView = rightView2
        addressField.rightViewMode = .always
    }

    private func changeAmountStatus(verify: Bool) {
        if (verify) {
            errorLabel.isHidden = true
            confirmButton.backgroundColor = UIColor(key: "regular")
            confirmButton.isEnabled = true
        } else {
            errorLabel.isHidden = false
            confirmButton.backgroundColor = UIColor(key: "light")
            confirmButton.isEnabled = false
        }
    }

    private func checkAmount() {
        guard let balanceBig = Web3Utils.parseToBigUInt(amountField.text!, decimals: decimals) else {
            self.errorLabel.text = "올바르지 않은 형식입니다."
            changeAmountStatus(verify: false)
            return
        }
        if (balanceBig == 0) {
            self.errorLabel.text = ""
            changeAmountStatus(verify: false)
            return
        }
        if (self.balance! < balanceBig) {
            self.errorLabel.text = "보유 잔액이 부족합니다."
            changeAmountStatus(verify: false)
            return
        }
        changeAmountStatus(verify: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AmountCell

        switch (indexPath.item) {
        case 0:
            cell.addLabel.text = "+0.001"
            break
        case 1:
            cell.addLabel.text = "+0.005"
            break
        case 2:
            cell.addLabel.text = "+0.01"
            break
        case 3:
            cell.addLabel.text = "+0.05"
            break
        case 4:
            cell.addLabel.text = "전체"
            break
        default:
            break
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var amount: BigUInt!

        if (amountField.text?.count == 0) {
            amount = BigUInt(0)
        } else {
            amount = Web3Utils.parseToBigUInt(amountField.text!, decimals: decimals)
        }

        switch (indexPath.item) {
        case 0:
            amount += BigUInt(1000000000000000)
            break
        case 1:
            amount += BigUInt(5000000000000000)
            break
        case 2:
            amount += BigUInt(10000000000000000)
            break
        case 3:
            amount += BigUInt(50000000000000000)
            break
        case 4:
            amount = self.balance
            break
        default:
            break
        }
        amountField.text = util.trimZero(balance: Web3Utils.formatToEthereumUnits(amount, decimals: decimals))
        checkAmount()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = screenSize.height / 30
        let width = screenSize.width * 0.18

        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 42
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func qrCodeRead(value: String) {
        if(value.contains("ethereum:")){
            let stringArr = value.components(separatedBy: ":")
            if(stringArr.count > 1){
                self.checkQr(value: stringArr[1])
            }
            else{
                self.qrFail()
            }
        }
        else{
            self.checkQr(value: value)
        }
    }

    func checkQr(value: String){
        guard let _ = EthereumAddress(value) else {
            qrFail()
            return
        }
        self.addressField.text = value
    }

    func qrFail(){
        let alertVC = util.alert(title: "QR코드 오류", body: "올바른 주소 형식이 아닙니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in})
        self.present(alertVC, animated: false)
    }

    @objc private func amountInput(_ sender: UITextField) {
        checkAmount()
        guard let decimal = Decimal(string: sender.text!) else {
            return
        }
        if (decimal.significantFractionalDecimalDigits > 8) {
            let text = String(sender.text!.dropLast())
            sender.text = text
        }
        let decimalCount = sender.text!.filter {
            $0 == "."
        }.count
        if (decimalCount > 1) {
            let text = String(sender.text!.dropLast())
            sender.text = text
        }
    }

    @objc private func qrPressed(_ sender: UITapGestureRecognizer){
        let qrCodeVC = QRCodeVC()
        qrCodeVC.delegate = self
        self.present(UINavigationController(rootViewController: qrCodeVC), animated: true)
    }

    @objc private func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    @objc private func nextPressed(_ sender: UIButton) {
        var errorBody: String?
        let util = Util()
        let amount = amountField.text!
        let address = addressField.text!

        do {
            self.showSpinner()
            try web3.preTransfer(address: address, amount: amount, completion: {(tx, estimateGas, subInfo) in
                DispatchQueue.main.async{
                    guard let _ = tx else{
                        let alertVC = util.alert(title: "전송 오류", body: "올바르지 않은 주소입니다. 주소를 확인해주세요.", buttonTitle: "확인", buttonNum: 1, completion: { _ in
                            self.hideSpinner()
                        })
                        self.present(alertVC, animated: false)
                        return
                    }

                    self.hideSpinner()
                    let total = Web3Utils.parseToBigUInt(amount, decimals: self.decimals)! + estimateGas!
                    let info = TransferInfo(amount: Web3Utils.parseToBigUInt(amount, decimals: self.decimals)!,
                            address: address, gas: estimateGas!, total: total, symbol: self.symbol, decimals: self.decimals)
                    let confirmVC = util.alert(use: "transfer", title: "전송 확인", info: info, balance: self.balance, isToken: self.symbol != "ETH",
                            buttonTitle: "전송", buttonNum: 2, completion: { (confirm) in
                        if(confirm){
                            let controller = PasswordCheckVC()
                            controller.toView = "transfer"
                            controller.tempTx = tx
                            controller.subInfo = subInfo
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    })
                    self.present(confirmVC, animated: false)
                }
            })
        } catch TransferError.invalidAmount {
            errorBody = "전송 금액을 확인해주세요."
        } catch TransferError.invalidAddress {
            errorBody = "올바르지 않은 주소입니다. 주소를 확인해주세요."
        } catch TransferError.insufficientAmount {
            errorBody = "잔액이 부족합니다."
        } catch TransferError.transferToSelf{
            errorBody = "자기 자신에게는 송금할 수 없습니다."
        } catch {
            errorBody = "기타 오류."
        }
        if(errorBody != nil){
            let alertVC = util.alert(title: "암호화폐 전송 오류", body: errorBody!, buttonTitle: "확인", buttonNum: 1, completion: {_ in
                self.hideSpinner()
            })
            self.present(alertVC, animated: false)
        }
    }
}
