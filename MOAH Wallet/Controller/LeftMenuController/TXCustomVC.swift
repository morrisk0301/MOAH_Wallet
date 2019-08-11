//
// Created by 김경인 on 2019-08-02.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import BigInt
import web3swift

class TXCustomVC: UIViewController, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3

    var keyboardHeight: CGFloat?
    var keyboardShown = false
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?

    var price: BigUInt?
    var limit: BigUInt?

    let priceLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "가스 가격"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let limitLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "가스 한도"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let priceField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "가스 가격을 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    let limitField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "가스 한도를 입력해주세요."
        textField.borderStyle = .none
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    let warningLabel: UILabel = {
        let label = UILabel()

        label.text = """
                     가스 가격이 높아질수록 전송 속도가 빨라 집니다.\n
                     가스 한도는 사용할 가스의 최대치를 의미합니다.\n
                     가스 한도가 너무 낮으면 전송이 거절될 수 있으니, 적절한 한도를 설정하시기 바랍니다.\n
                     가스 한도나 가격을 너무 높게 설정하면 Block Gas Limit을 초과하여 전송이 불가할 수 있습니다.\n  
                     """
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name:"NanumSquareRoundR", size: 14, dynamic: true)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("가스 설정하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.replaceBackButton(color: "dark")
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "사용자 지정")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")

        priceField.delegate = self
        limitField.delegate = self

        if(price != nil){
            priceField.text = Web3Utils.formatToEthereumUnits(price!, toUnits: .Gwei)
            limitField.text = limit?.description
        }

        view.addSubview(priceLabel)
        view.addSubview(limitLabel)
        view.addSubview(priceField)
        view.addSubview(limitField)
        view.addSubview(warningLabel)
        view.addSubview(confirmButton)

        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width*0.15, height: screenSize.height/20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenSize.width*0.15, height: screenSize.height/20))
        label.text = "GWei"
        label.textColor = UIColor(key: "darker")
        label.font = UIFont(name: "NanumSquareRoundB", size: 16, dynamic: true)
        label.textAlignment = .center
        rightView.addSubview(label)

        priceField.rightView = rightView
        priceField.rightViewMode = .always

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
        priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        priceField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true
        priceField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        priceField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        limitLabel.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: screenSize.height/30).isActive = true
        limitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        limitLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        limitLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        limitField.topAnchor.constraint(equalTo: limitLabel.bottomAnchor).isActive = true
        limitField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        limitField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        limitField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        warningLabel.topAnchor.constraint(equalTo: limitField.bottomAnchor, constant: screenSize.height/30).isActive = true
        warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        warningLabel.heightAnchor.constraint(equalToConstant: screenSize.height/4).isActive = true
        warningLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        hideConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20)
        hideConstraint!.isActive = true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 18
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc private func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue

            if (keyboardHeight == nil) {
                keyboardHeight = keyboardRectangle.height
            }
            if (!keyboardShown || keyboardHeight! < keyboardRectangle.height) {
                if (showConstraint != nil) {
                    showConstraint!.isActive = false
                }
                showConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardRectangle.height)
                hideConstraint!.isActive = false
                showConstraint!.isActive = true
                keyboardHeight = keyboardRectangle.height
                keyboardShown = true
            }
        }
    }

    @objc private func keyboardWillHide(_ sender: Notification) {
        if (keyboardShown) {
            showConstraint!.isActive = false
            hideConstraint!.isActive = true
            keyboardShown = false
        }
    }

    @objc private func nextPressed(_ sender:UIButton){
        let util = Util()
        if(priceField.text?.count == 0 || BigUInt(priceField.text!) == nil){
            let alertVC = util.alert(title: "가스 설정 오류", body: "가스 가격 값이 올바르지 않습니다. 가스 가격 값을 확인해주세요.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
            })
            self.present(alertVC, animated: false)
        }
        else if(limitField.text?.count == 0) || BigUInt(limitField.text!) == nil {
            let alertVC = util.alert(title: "가스 설정 오류", body: "가스 한도 값이 올바르지 않습니다. 가스 한도 값을 확인해주세요.", buttonTitle: "확인", buttonNum: 1, completion: { _ in
            })
            self.present(alertVC, animated: false)
        }
        else{
            let price = BigUInt(Int(priceField.text!)! * 1000000000)
            let limit = BigUInt(limitField.text!)

            web3.setGas(price: price, limit: limit!)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
