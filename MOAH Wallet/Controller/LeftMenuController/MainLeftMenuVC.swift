//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift

class MainLeftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private let reuseIdentifer = "LeftMenuCell"

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.accountInstance
    let util = Util()

    var delegate: MainControllerDelegate?

    var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeftMenuCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.rowHeight = screenSize.height/15
        tableView.isScrollEnabled = false

        view.addSubview(tableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! LeftMenuCell
        cell.descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/3.3).isActive = true

        let menuOption = LeftMenuOption(rawValue: indexPath.row)
        if(indexPath.row == 0){
            let border = CALayer()
            border.backgroundColor = UIColor(key: "grey").cgColor
            border.frame = CGRect(x:0, y: cell.frame.height*0.95, width: screenSize.width, height: 0.5)

            cell.descriptionLabel.text = account.getAddressName()

            cell.descriptionLabel.font = UIFont(name:"NanumSquareRoundB", size: 22, dynamic: true)!
            cell.descriptionLabel.textColor = UIColor(key: "darker")
            cell.descriptionLabel.textAlignment = .center
            cell.descriptionLabel.numberOfLines = 0
            cell.descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/20).isActive = true
            cell.layer.addSublayer(border)
            cell.arrowImage.isHidden = true

            let address = account.getAddress()
            cell.addressText.text = address?.description

            let qrImage = util.generateQRCode(source: address?.description)
            cell.qrCodeImage.image = qrImage

            cell.addSubview(cell.qrCodeImage)
            cell.qrCodeImage.topAnchor.constraint(equalTo: cell.descriptionLabel.bottomAnchor, constant: screenSize.height/20).isActive = true
            cell.qrCodeImage.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -screenSize.width/9).isActive = true
            cell.qrCodeImage.heightAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true
            cell.qrCodeImage.widthAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true

            cell.addSubview(cell.addressText)
            cell.addressText.topAnchor.constraint(equalTo: cell.qrCodeImage.bottomAnchor, constant: screenSize.height/15).isActive = true
            cell.addressText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/9).isActive = true
            cell.addressText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/3.3).isActive = true
            cell.addressText.heightAnchor.constraint(equalToConstant: screenSize.height/8).isActive = true

            return cell
        }
        cell.descriptionLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        cell.descriptionLabel.text = menuOption?.description

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return screenSize.height/1.5
        }
        return screenSize.height/15
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = LeftMenuOption(rawValue: indexPath.row)
        delegate?.leftSideMenuClicked(forMenuOption: menuOption)
    }

    private func setupLayout(){
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}