//
// Created by 김경인 on 2019-07-25.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class TokenSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TokenObserver {

    private let reuseIdentifier = "TokenSelectCell"

    let screenSize = UIScreen.main.bounds
    let ethToken = EthToken.token

    var alertTitle: String?
    var alertBody: String?
    var alertButtonTitle: String?
    var delegate: MainControllerDelegate?
    var tokenArray: [TokenInfo]!
    var token: CustomToken?
    var isInit = false
    var id: String = "TokenSelectVC"

    let alertView: UIView = {
        let view = UIView()

        view.backgroundColor = .white
        view.isOpaque = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 100, height: 50))

        label.textColor = UIColor(key: "darker")
        label.textAlignment = .center
        label.font = UIFont(name:"NanumSquareRoundB", size: 20, dynamic: true)
        label.text = "암호화폐 선택"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont(name:"NanumSquareRoundB", size: 16, dynamic: true)
        button.setTitleColor(UIColor(key: "dark"), for: .normal)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)

        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let checkImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkDark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    init(){
        self.token = ethToken.token
        super.init(nibName: nil, bundle: nil)
        ethToken.attachTokenObserver(self)
        isInit = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TokenCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(!isInit){
            self.token = ethToken.token
            ethToken.attachTokenObserver(self)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        ethToken.detachTokenObserver(self)
    }

    private func setupLayout(){
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true

        addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height/200).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: screenSize.height/16).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: screenSize.width/10).isActive = true

        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func addCheckImage(cell: UITableViewCell){
        cell.addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -screenSize.width/15).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/30).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/22.5).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TokenCell
        if(indexPath.row == 0){
            cell.setAsEther()
            if(token == nil){ addCheckImage(cell: cell) }
            return cell
        }
        let name = tokenArray[indexPath.row-1].value(forKey: "name") as! String
        let symbol = tokenArray[indexPath.row-1].value(forKey: "symbol") as! String
        let address = tokenArray[indexPath.row-1].value(forKey: "address") as! String

        let nameLabel = symbol + " - " + name
        cell.setTokenValue(name: nameLabel, address: address, logo: nil)

        if(self.token != nil && address == self.token!.address){
            addCheckImage(cell: cell)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokenArray.count + 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/15
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioServicesPlaySystemSound(1519)
        if(indexPath.row == 0){
            ethToken.setToken(index: nil)
        }
        else{
            ethToken.setToken(index: indexPath.row-1)
        }
        tableView.reloadData()
        self.delegate?.tokenEnded(selected: true)
    }

    func tokenChanged(token: CustomToken?) {
        self.token = token
    }

    @objc func addPressed(_ sender: UIButton){
        self.delegate?.tokenEnded(selected: false)
    }

}
