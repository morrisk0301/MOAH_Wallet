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
    private var _task = [String]()

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
        let web3 = CustomWeb3.shared
        let ethTXHistory = EthTXHistory()
        if(_checkTask(txHash)) { return }

        _queue.sync{
            var count = 0
            while(true){
                count += 1
                let hash = web3.getTXReceipt(hash: txHash)
                if(hash != nil && hash!.status != .notYetProcessed){
                    ethTXHistory.updateTXStatus(tx: txHash, status: hash!.status.description)
                    _popTask(txHash)
                    self.delegate?.transactionComplete()
                    break
                }
                if(count>10 || txHash.count == 0){break}
                sleep(10)
            }
        }
    }

    private func _checkTask(_ txHash: String) -> Bool{
        for task in _task{
            if(task == txHash){
                return true
            }
        }
        _addTask(txHash)
        return false
    }

    private func _addTask(_ task: String){
        _task.append(task)
    }

    private func _popTask(_ task: String){
        if let index = _task.firstIndex(of: task) {
            _task.remove(at: index)
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
