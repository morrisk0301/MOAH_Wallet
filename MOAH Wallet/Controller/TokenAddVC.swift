//
// Created by 김경인 on 2019-08-11.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TokenAddVC: UIViewController, UITextFieldDelegate {

    let screenSize = UIScreen.main.bounds
    var token: CustomToken?

    let contractLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  컨트랙트 주소"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let symbolLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  토큰 심볼"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let decimalLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  소숫점 자리수"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont(name:"NanumSquareRoundB", size: 14, dynamic: true)
        label.textColor = UIColor(key: "darker")
        label.text = "  토큰명"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let contractField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "토큰 컨트랙트 주소를 입력해주세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 0
        textField.addTarget(self, action: #selector(contractInput(_:)), for: .editingDidEnd)

        return textField
    }()

    let symbolField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.tag = 1

        return textField
    }()

    let decimalField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.tag = 1

        return textField
    }()

    let nameField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.tag = 1

        return textField
    }()

    let confirmButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("추가하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.isEnabled = false
        button.backgroundColor = UIColor(key: "light")
        button.addTarget(self, action: #selector(nextPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceBackButton(color: "dark")
        self.setNavigationTitle(title: "토큰 직접 추가")
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(contractLabel)
        view.addSubview(symbolLabel)
        view.addSubview(decimalLabel)
        view.addSubview(nameLabel)
        view.addSubview(contractField)
        view.addSubview(symbolField)
        view.addSubview(decimalField)
        view.addSubview(nameField)
        view.addSubview(confirmButton)

        contractField.delegate = self
        symbolField.delegate = self
        decimalField.delegate = self
        nameField.delegate = self

        contractField.clearButtonMode = .whileEditing

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        contractLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/30).isActive = true
        contractLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contractLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        contractLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        contractField.topAnchor.constraint(equalTo: contractLabel.bottomAnchor).isActive = true
        contractField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contractField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        contractField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        symbolLabel.topAnchor.constraint(equalTo: contractField.bottomAnchor, constant: screenSize.height/30).isActive = true
        symbolLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        symbolLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        symbolLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        symbolField.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor).isActive = true
        symbolField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        symbolField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        symbolField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        decimalLabel.topAnchor.constraint(equalTo: symbolField.bottomAnchor, constant: screenSize.height/30).isActive = true
        decimalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        decimalLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        decimalLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        decimalField.topAnchor.constraint(equalTo: decimalLabel.bottomAnchor).isActive = true
        decimalField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        decimalField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        decimalField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        nameLabel.topAnchor.constraint(equalTo: decimalField.bottomAnchor, constant: screenSize.height/30).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: screenSize.height/25).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true
        nameField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true

        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc func contractInput(_ sender: UITextField){
        if(contractField.text!.count == 0){ return }
        let token = EthToken.shared
        let util = Util()
        var errorBody: String?
        self.showSpinner()

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let getToken = try token.getTokenInfo(address: self.contractField.text!)
                let defaultImage = UIImage(named: "token")
                let imageData = defaultImage!.pngData()
                self.token = getToken
                self.token!.logo = imageData

                DispatchQueue.main.async {
                    self.symbolField.text = getToken.symbol
                    self.decimalField.text = getToken.decimals.description
                    self.nameField.text = getToken.name
                    self.confirmButton.isEnabled = true
                    self.confirmButton.backgroundColor = UIColor(key: "regular")
                    self.hideSpinner()
                    return
                }
            } catch GetTokenError.invalidAddress {
                errorBody = "올바르지 않은 주소입니다.\n주소를 확인해주세요."
            } catch GetTokenError.tokenNil {
                errorBody = "토큰을 확인할 수 없습니다."
            } catch GetTokenError.existingToken{
                errorBody = "이미 추가된 토큰입니다."
            } catch {
                errorBody = "토큰을 확인할 수 없습니다."
            }
            if(errorBody != nil){
                DispatchQueue.main.async {
                    let alertVC = util.alert(title: "토큰 추가 오류", body: errorBody!, buttonTitle: "확인", buttonNum: 1, completion: { _ in
                        self.hideSpinner()
                        self.contractField.text = ""
                    })
                    self.present(alertVC, animated: false)
                }
            }
        }
    }

    @objc func nextPressed(_ sender: UIButton) {
        let util = Util()
        let ethToken = EthToken.shared
        ethToken.addToken(self.token!)

        let alertVC = util.alert(title: "토큰 추가", body: token!.symbol+" 토큰 추가를 완료하였습니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in
            self.reloadMainContainerVC()
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alertVC, animated: false)
    }

}
