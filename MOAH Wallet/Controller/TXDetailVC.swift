//
// Created by 김경인 on 2019-08-16.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UIKit

class TXDetailVC: UIViewController{

    var txInfo: TXInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.transparentNavigationBar()
        self.replaceToQuitButton(color: "dark")
        self.setNavigationTitle(title: "거래 상세정보")

        view.backgroundColor = UIColor(key: "light3")

        self.showSpinner()
        loadTxData()
        print(self.txInfo.txHash)

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupLayout(){

    }

    private func loadTxData(){
        let web3: CustomWeb3 = CustomWeb3.web3
        DispatchQueue.global(qos: .userInteractive).async{
            let txReceipt = web3.getTXReceipt(hash: self.txInfo.txHash)
            let txDetail = web3.getTXDetail(hash: self.txInfo.txHash)
            print(txReceipt)
            print(txDetail)
            self.setValue()
            //self.hideSpinner()
        }
    }

    private func setValue(){

    }
}
