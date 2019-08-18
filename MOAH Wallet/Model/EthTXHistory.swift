//
// Created by 김경인 on 2019-08-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import CoreData
import web3swift

class EthTXHistory: NetworkObserver, AddressObserver {

    private var network: CustomWeb3Network
    private var address: CustomAddress
    private let txQueue = DispatchQueue.global(qos: .background)

    var delegate: TransactionDelegate?
    var id: String = "ETHTXHistory"

    private var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.persistentContainer.viewContext
    }

    init(){
        let web3: CustomWeb3 = CustomWeb3.web3
        let ethAddress = EthAddress.address
        self.network = web3.network!
        self.address = ethAddress.address!
        web3.attachNetworkObserver(self)
        ethAddress.attachAddressObserver(self)
    }

    func initTXInfo(tx: String, error: String, subInfo: TXSubInfo) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "TXInfo", in: managedContext) else { return }

        let util = Util()
        let newTX = NSManagedObject(entity: entity, insertInto: managedContext)
        let status = error == "" ? "notYetProcessed" : "failed"
        let amount = util.trimZero(balance: Web3Utils.formatToEthereumUnits(subInfo.amount, decimals: subInfo.decimals)!)
        let gasPrice = util.trimZero(balance: Web3Utils.formatToEthereumUnits(subInfo.gasPrice, toUnits: .Gwei)!)
        let gasLimit = util.trimZero(balance: Web3Utils.formatToEthereumUnits(subInfo.gasLimit, toUnits: .wei)!)

        newTX.setValue(address.address, forKey: "account")
        newTX.setValue(amount, forKey: "amount")
        newTX.setValue(subInfo.category, forKey: "category")
        newTX.setValue(Date(), forKey: "date")
        newTX.setValue(subInfo.decimals, forKey: "decimals")
        newTX.setValue(error, forKey: "error")
        newTX.setValue(address.address, forKey: "from")
        newTX.setValue(gasLimit, forKey: "gasLimit")
        newTX.setValue(gasPrice, forKey: "gasPrice")
        newTX.setValue(network.name, forKey: "network")
        newTX.setValue(status, forKey: "status")
        newTX.setValue(subInfo.symbol, forKey: "symbol")
        newTX.setValue(subInfo.to, forKey: "to")
        newTX.setValue(tx, forKey: "txHash")

        do {
            try managedContext.save()
            let txQueue = TXQueue.queue
            txQueue.addTXTask(txHash: tx)
        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func fetchTXInfo() -> [TXInfo] {
        guard let managedContext = managedContext else {
            return []
        }
        let fetchRequest = NSFetchRequest<TXInfo>(entityName: "TXInfo")
        let networkPredicate = NSPredicate(format: "network = %@", network.name)
        let accountPredicate = NSPredicate(format: "account = %@", address.address)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [networkPredicate, accountPredicate])
        fetchRequest.predicate = andPredicate

        do {
            let result = try managedContext.fetch(fetchRequest)
            return _sortTxBackwards(array: result)
        } catch let error as NSError {
            print("error : \(error)")
        }

        return []
    }

    func updateTXStatus(tx: String, status: String){
        guard let managedContext = managedContext else { return }

        let fetchRequest = NSFetchRequest<TXInfo>(entityName: "TXInfo")
        let hashPredicate = NSPredicate(format: "txHash = %@", tx)
        fetchRequest.predicate = hashPredicate

        do {
            let result = try managedContext.fetch(fetchRequest)

            let objectUpdate = result[0]
            objectUpdate.setValue(status, forKey: "status")

            try managedContext.save()

        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func networkChanged(network: CustomWeb3Network) {
        self.network = network
    }

    func addressChanged(address: CustomAddress) {
        self.address = address
    }

    private func _sortTxBackwards(array: [TXInfo]) -> [TXInfo] {
        var arrayModified = [TXInfo]()

        for i in (0..<array.count).reversed(){
            arrayModified.append(array[i])
        }

        return arrayModified
    }
}
