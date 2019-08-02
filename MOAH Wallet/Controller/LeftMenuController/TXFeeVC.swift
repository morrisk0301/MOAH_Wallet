//
// Created by 김경인 on 2019-07-29.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit
import BigInt

class TXFeeVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    private let reuseIdentifier = "TXCell"

    let screenSize = UIScreen.main.bounds
    let web3: CustomWeb3 = CustomWeb3.web3

    var price: BigUInt?
    var limit: BigUInt?

    let tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = UIColor(key: "light3")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    let checkImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkMenu"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.setNavigationTitle(title: "전송 수수료 설정")
        self.replaceBackButton(color: "dark")

        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backPressed(_:))

        view.backgroundColor = UIColor(key: "light3")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)

        view.addSubview(tableView)

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func addCheckImage(cell: UITableViewCell){
        cell.addSubview(checkImage)

        checkImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        checkImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -screenSize.width/10).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: screenSize.width/30).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: screenSize.width/22.5).isActive = true
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        let gas = web3.getGas()

        cell.arrowImage.isHidden = true

        switch(indexPath.row){
        case 0:
            if(gas?.rate == "low"){ addCheckImage(cell: cell)}
            let attrText = NSMutableAttributedString(string: "낮음", 
                    attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)!, 
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
            attrText.append(NSAttributedString(string: " (가스 가격: 4 GWei / 가스 한도 21000)",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))
            cell.menuLabel.attributedText = attrText
            break
        case 1:
            if(gas?.rate == "mid"){ addCheckImage(cell: cell)}
            let attrText = NSMutableAttributedString(string: "보통",
                    attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
            attrText.append(NSAttributedString(string: " (가스 가격: 10 GWei / 가스 한도 21000)",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))
            cell.menuLabel.attributedText = attrText
            break
        case 2:
            if(gas?.rate == "high"){ addCheckImage(cell: cell)}
            let attrText = NSMutableAttributedString(string: "높음",
                    attributes: [NSAttributedString.Key.font: UIFont(name:"NanumSquareRoundR", size: 16, dynamic: true)!,
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")])
            attrText.append(NSAttributedString(string: " (가스 가격: 20 GWei / 가스 한도 21000)",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                 NSAttributedString.Key.foregroundColor: UIColor(key: "darker")]))
            cell.menuLabel.attributedText = attrText
            break
        case 3:
            if(gas?.rate == "custom"){ addCheckImage(cell: cell)}
            cell.menuLabel.text = "사용자 지정"
            self.price = gas?.price
            self.limit = gas?.limit

            break
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
            case 0:
                web3.setGas(rate: "low")
                break
            case 1:
                web3.setGas(rate: "mid")
                break
            case 2:
                web3.setGas(rate: "high")
                break
            case 3:
                let controller = TXCustomVC()
                controller.price = self.price
                controller.limit = self.limit
                self.navigationController?.pushViewController(controller, animated: true)
                break
            default:
                break
        }
        self.tableView.reloadData()
    }

    @objc func backPressed(_ sender: UIButton){
        self.dismiss(animated: true)
    }
}
