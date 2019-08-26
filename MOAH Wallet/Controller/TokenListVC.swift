//
// Created by 김경인 on 2019-08-10.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class TokenListVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let reuseIdentifier = "TokenCell"

    var tokenArr: [CustomToken] = [CustomToken]()

    let screenSize = UIScreen.main.bounds
    let httpRequest = HTTPRequest()
    let web3 = CustomWeb3.shared
    let util = Util()
    let ethToken = EthToken.shared

    let searchField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "토큰명/심볼/Contract 주소를 입력하세요."
        textField.borderStyle = .none
        textField.returnKeyType = .search
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(searchToken(_:)), for: .editingDidEndOnExit)

        return textField
    }()

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setTitle("토큰 직접 추가", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 18, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "토큰 검색")
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TokenCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.backgroundColor = UIColor(key: "light3")

        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(searchField)
        searchField.delegate = self
        searchField.clearButtonMode = .whileEditing

        if(web3.network!.name != "mainnet"){
            self.searchField.isEnabled = false
        }

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/40).isActive = true
        searchField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchField.widthAnchor.constraint(equalToConstant: screenSize.width*0.9).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: screenSize.height/15).isActive = true

        tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: screenSize.height/40).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor).isActive = true

        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height/20).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TokenCell

        tableView.isScrollEnabled = true

        if(web3.network!.name != "mainnet"){
            tableView.isScrollEnabled = false
            self.searchField.isEnabled = false
            cell.isUserInteractionEnabled = false
            cell.noSearch()

            return cell
        }

        let nameLabel = tokenArr[indexPath.row].symbol + " - " + tokenArr[indexPath.row].name
        cell.setTokenValue(name: nameLabel, address: tokenArr[indexPath.row].address, logo: tokenArr[indexPath.row].logo!)

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(web3.network!.name != "mainnet"){
            return 1
        }

        return tokenArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/12
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async{
            AudioServicesPlaySystemSound(1519)
            guard !self.ethToken.checkTokenExists(address: self.tokenArr[indexPath.row].address) else{
                let alertVC = self.util.alert(title: "Error".localized, body: "이미 추가된 토큰입니다.",
                        buttonTitle: "확인", buttonNum: 1, completion: {_ in })
                self.present(alertVC, animated: false)

                return
            }

            self.ethToken.addToken(self.tokenArr[indexPath.row])

            let alertVC = self.util.alert(title: "토큰 추가", body: self.tokenArr[indexPath.row].symbol+" 토큰 추가를 완료하였습니다.",
                    buttonTitle: "추가", buttonNum: 1, completion: {_ in })

            self.present(alertVC, animated: false)
            self.reloadMainContainerVC()
        }
    }

    @objc private func addPressed(_ sender: UIButton){
        let controller = TokenAddVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func searchToken(_ sender: UITextField){
        self.showSpinner()
        self.tableView.scroll(to: .top, animated: false)
        if(searchField.text!.count == 0){
            httpRequest.tokenSearch(request: .searchAll, params: "", completion: { result in
                self.tokenArr = result
                self.tableView.reloadData()
                self.hideSpinner()
            })
        }
        else{
            httpRequest.tokenSearch(request: .search, params: searchField.text!, completion: { result in
                self.tokenArr = result
                self.tableView.reloadData()
                self.hideSpinner()
            })
        }

    }
}
