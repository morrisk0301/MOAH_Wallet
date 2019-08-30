//
// Created by 김경인 on 2019-07-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import web3swift

class MainLeftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddressObserver{

    private let reuseIdentifier = "LeftMenuCell"

    let screenSize = UIScreen.main.bounds
    let account: EthAccount = EthAccount.shared
    let ethAddress = EthAddress.address
    var address: CustomAddress
    let util = Util()

    var delegate: MainControllerDelegate?
    var isInit = true
    var id: String = "MainLeftMenuVC"
    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let versionLabel: UILabel = {
        let label = UILabel()

        label.text = "v" + AppSetting.APPVERSION
        label.textColor = UIColor(key: "grey2")
        label.font = UIFont(name:"NanumSquareRoundR", size: 14, dynamic: true)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    init(){
        self.address = ethAddress.address!
        super.init(nibName: nil, bundle: nil)
        ethAddress.attachAddressObserver(self)
        isInit = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeftMenuCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = screenSize.height/15
        tableView.isScrollEnabled = false

        view.addSubview(tableView)
        view.addSubview(versionLabel)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(!isInit){
            self.address = ethAddress.address!
            ethAddress.attachAddressObserver(self)
        }
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        ethAddress.detachAddressObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LeftMenuCell
        cell.descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/3.3).isActive = true

        let menuOption = LeftMenuOption(rawValue: indexPath.row)
        if(indexPath.row == 0){
            mainCellLayout(cell: cell)

            return cell
        }
        cell.descriptionLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        cell.descriptionLabel.text = menuOption?.description

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return screenSize.height*0.6
        }
        return screenSize.height/15
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = LeftMenuOption(rawValue: indexPath.row)
        delegate?.leftSideMenuClicked(forMenuOption: menuOption)
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: versionLabel.topAnchor).isActive = true

        versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -screenSize.width/10).isActive = true
        versionLabel.widthAnchor.constraint(equalToConstant: screenSize.width/2).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: screenSize.height/50).isActive = true
    }

    private func mainCellLayout(cell: LeftMenuCell){
        let border = CALayer()
        border.backgroundColor = UIColor(key: "grey").cgColor
        border.frame = CGRect(x:0, y: cell.frame.height*0.95, width: screenSize.width, height: 0.5)

        cell.descriptionLabel.text = address.name

        cell.descriptionLabel.font = UIFont(name:"NanumSquareRoundB", size: 22, dynamic: true)!
        cell.descriptionLabel.textColor = UIColor(key: "darker")
        cell.descriptionLabel.textAlignment = .center
        cell.descriptionLabel.numberOfLines = 0
        cell.descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height/20).isActive = true
        cell.layer.addSublayer(border)

        cell.addressButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        cell.txFeeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        cell.addSubview(cell.qrCodeImage)
        cell.addSubview(cell.addressLabel)
        cell.addSubview(cell.addressButton)
        cell.addSubview(cell.txFeeButton)

        cell.addressLabel.text = address.address

        let qrImage = util.generateQRCode(source: address.address)
        cell.qrCodeImage.image = qrImage

        cell.qrCodeImage.topAnchor.constraint(equalTo: cell.descriptionLabel.bottomAnchor, constant: screenSize.height/30).isActive = true
        cell.qrCodeImage.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -screenSize.width/10).isActive = true
        cell.qrCodeImage.heightAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true
        cell.qrCodeImage.widthAnchor.constraint(equalToConstant: screenSize.height/5).isActive = true

        cell.addressButton.topAnchor.constraint(equalTo: cell.qrCodeImage.bottomAnchor, constant: screenSize.height/25).isActive = true
        cell.addressButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -screenSize.width/10 - screenSize.width/6).isActive = true
        cell.addressButton.widthAnchor.constraint(equalToConstant: screenSize.width/4).isActive = true
        cell.addressButton.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true

        cell.txFeeButton.topAnchor.constraint(equalTo: cell.qrCodeImage.bottomAnchor, constant: screenSize.height/25).isActive = true
        cell.txFeeButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -screenSize.width/10 + screenSize.width/6).isActive = true
        cell.txFeeButton.widthAnchor.constraint(equalToConstant: screenSize.width/4).isActive = true
        cell.txFeeButton.heightAnchor.constraint(equalToConstant: screenSize.height/20).isActive = true

        cell.addressLabel.topAnchor.constraint(equalTo: cell.addressButton.bottomAnchor, constant: screenSize.height/35).isActive = true
        cell.addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenSize.width/10).isActive = true
        cell.addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenSize.width/3.3).isActive = true
        cell.addressLabel.heightAnchor.constraint(equalToConstant: screenSize.height/17).isActive = true
    }

    func addressChanged(address: CustomAddress) {
        self.address = address
    }

    @objc func buttonPressed(_ sender: UIButton){
        if(sender.tag == 0){
            UIPasteboard.general.string = self.address.address
            let alertVC = util.alert(title: "Copy Address".localized, body: "Address has been copied to clipboard.".localized, buttonTitle: "Confirm".localized, buttonNum: 1, completion: {_ in
            })
            self.present(alertVC, animated: false)
        }
        else if(sender.tag == 1){
            delegate?.txFeeClicked()
        }
    }
}