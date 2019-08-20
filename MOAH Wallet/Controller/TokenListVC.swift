//
// Created by 김경인 on 2019-08-10.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TokenListVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    private let reuseIdentifier = "TokenCell"

    let screenSize = UIScreen.main.bounds
    let httpRequest = HTTPRequest()

    let searchField: UITextField = {
        let textField = UITextField()

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "토큰명/Contract 주소를 입력하세요."
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.textColor = UIColor(key: "darker")
        textField.font = UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor(key: "grey2").cgColor
        textField.layer.borderWidth = 0.5
        textField.keyboardType = .asciiCapable
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(searchToken(_:)), for: .editingDidEnd)

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
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "토큰 선택")
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

        setupLayout()
        self.showSpinner()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TokenCell

        if(indexPath.row == 0){
            cell.logoImageView.isHidden = true
        }
        else{
            //cell.setTokenValue(name: "NaraMalsamiToken", address: "0x9e45b139922836616459385088531ae2a24f49a1", logo: nil)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return screenSize.height/10
        }else{
            return screenSize.height/15
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){ return }
        let util = Util()
        let alertVC = util.alert(title: "토큰 추가", body: "NMT 토큰 추가를 완료하였습니다.", buttonTitle: "확인", buttonNum: 1, completion: {_ in

        })
        self.present(alertVC, animated: false)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.hideSpinner()
    }

    @objc private func addPressed(_ sender: UIButton){
        let controller = TokenAddVC()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func searchToken(_ sender: UITextField){
        self.showSpinner()
        if(searchField.text!.count == 0){
            httpRequest.tokenSearch(request: .searchAll, params: "", completion: { _ in

            })
        }
        else{
            httpRequest.tokenSearch(request: .search, params: searchField.text!, completion: { _ in

            })
        }

    }
}
