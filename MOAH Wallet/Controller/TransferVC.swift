//
// Created by 김경인 on 2019-08-06.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TransferVC: UIViewController{

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3
    var balance: String!
    var symbol: String!

    lazy var balanceLabel: UILabel = {
        let label = UILabel()

        let attrText = NSMutableAttributedString(string: self.balance+" ",
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 30, dynamic: true)!, 
                             NSAttributedString.Key.foregroundColor: UIColor(key: "regular")])
        attrText.append(NSAttributedString(string: self.symbol,
                attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundB", size: 30, dynamic: true)!,
                             NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))

        label.attributedText = attrText
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundR", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  보낼 금액"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addressLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundR", size: 14, dynamic: true)
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
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.tag = 0

        return textField
    }()

    let amountCV: UICollectionView = {
        let collectionView = UICollectionView()

        collectionView.backgroundColor = UIColor(key: "light3")

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
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
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "암호화폐 전송")
        self.hideKeyboardWhenTappedAround()

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(balanceLabel)
        view.addSubview(amountLabel)
        view.addSubview(amountField)
        view.addSubview(addressLabel)
        view.addSubview(addressField)
        view.addSubview(warningLabel)
        view.addSubview(confirmButton)

        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:0, y: addressField.frame.height+screenSize.height/20, width: addressField.frame.width, height: 1)
        addressField.layer.addSublayer(border)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        balanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true

        amountLabel.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: screenSize.height/30).isActive = true
        amountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        amountLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        amountField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor).isActive = true
        amountField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        amountField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        amountField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        addressLabel.topAnchor.constraint(equalTo: amountField.bottomAnchor, constant: screenSize.height/30).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor).isActive = true
        addressField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        addressField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        warningLabel.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: screenSize.height/12).isActive = true
        warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/15).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/15).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/10).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    @objc private func backPressed(_ sender: UIBarButtonItem){
        self.dismiss(animated: true)
    }

    @objc private func nextPressed(_ sender: UIButton){
        var errorBody: String?
        let util = Util()
        let address = addressField.text!
        let amount = amountField.text!

        do{
            try web3.transfer(address: address, amount: amount)
            return
        }
        catch TransferError.invalidAmount{
            errorBody = "전송 금액을 확인해주세요."
        }
        catch TransferError.invalidAddress{
            errorBody = "올바르지 않은 주소입니다. 주소를 확인해주세요."
        }
        catch TransferError.insufficientAmount{
            errorBody = "잔액이 부족합니다."
        }
        catch{

        }
        let alertVC = util.alert(title: "전송 오류", body: errorBody!, buttonTitle: "확인", buttonNum: 1, completion: {_ in})
        self.present(alertVC, animated: false)
    }
}
