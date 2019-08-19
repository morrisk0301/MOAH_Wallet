//
// Created by 김경인 on 2019-08-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

class TXQueue {

    static let queue = TXQueue()

    private var _queue = DispatchQueue.global(qos: .utility)

    var delegate: TransactionDelegate?

    private init(){

    }

    func refreshTX(){
        DispatchQueue.global(qos: .userInitiated).async{
            let ethTXHistory = EthTXHistory()
            let txArray = ethTXHistory.fetchTXInfo()
            for tx in txArray{
                let hash = tx.value(forKey: "txHash") as! String
                let status = tx.value(forKey: "status") as! String
                if(status == "notYetProcessed"){
                    self.addTXTask(txHash: hash)
                }
            }
        }
    }

    func addTXTask(txHash: String){
        let web3 = CustomWeb3.web3
        let ethTXHistory = EthTXHistory()
        _queue.sync{
            while(true){
                let hash = web3.getTXReceipt(hash: txHash)
                if(hash != nil && hash!.status != .notYetProcessed){
                    ethTXHistory.updateTXStatus(tx: txHash, status: hash!.status.description)
                    self.delegate?.transactionComplete()
                    break
                }
                sleep(10)
            }
        }
    }

    /*
    private func _notifyUser(){
        let userDefaults = UserDefaults.standard
        guard userDefaults.bool(forKey: "alarm") else { return }

        UNUserNotificationCenter.current().getNotificationSettings{settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                let nContent = UNMutableNotificationContent()
                nContent.body = "*** 거래가 완료되었습니다."
                nContent.title = "MOAH Wallet"
                nContent.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "alarm", content: nContent, trigger: trigger)

                UNUserNotificationCenter.current().add(request){_ in}
            } else{
                return
            }
        }
    }
    */

}
