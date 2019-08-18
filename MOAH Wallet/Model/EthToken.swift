//
// Created by 김경인 on 2019-08-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import CoreData
import web3swift
import BigInt

class EthToken: NetworkObserver {

    static let token = EthToken()

    private let userDefaults = UserDefaults.standard

    private var _token: CustomToken?
    private var _network: CustomWeb3Network?
    private var observers: [TokenObserver] = [TokenObserver]()

    var id: String = "EthToken"
    var token: CustomToken? {
        set(value){
            _token = value
            _saveTokenSelected()
            notify()
        }
        get{
            return _token
        }
    }

    private init(){
        let web3 = CustomWeb3.web3
        self._network = web3.network
        web3.attachNetworkObserver(self)
        _loadTokenSelected()
    }

    private var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.persistentContainer.viewContext
    }

    func addToken(_ token: CustomToken) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "TokenInfo", in: managedContext) else { return }

        let newAddress = NSManagedObject(entity: entity, insertInto: managedContext)

        newAddress.setValue(token.address, forKey: "address")
        newAddress.setValue(token.name, forKey: "name")
        newAddress.setValue(token.symbol, forKey: "symbol")
        newAddress.setValue(token.decimals, forKey: "decimals")
        newAddress.setValue(token.network, forKey: "network")
        newAddress.setValue(token.logo, forKey: "logo")

        do {
            try managedContext.save()
            self.token = token
        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func fetchToken(_ predicate: NSPredicate?) -> [TokenInfo] {
        guard let managedContext = managedContext else {
            return []
        }

        let fetchRequest = NSFetchRequest<TokenInfo>(entityName: "TokenInfo")
        fetchRequest.predicate = predicate

        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("error : \(error)")
        }

        return []
    }

    func deleteToken(address: String){
        guard let managedContext = managedContext else { return }

        let fetchRequest = NSFetchRequest<TokenInfo>(entityName: "TokenInfo")
        let addressPredicate = NSPredicate(format: "address = %@", address)
        fetchRequest.predicate = addressPredicate

        do {
            let result = try managedContext.fetch(fetchRequest)

            let objectDelete = result[0]
            managedContext.delete(objectDelete)

            try managedContext.save()

        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func setToken(index: Int?) {
        if(index == nil) {
            self.token = nil
            _deleteTokenSelected()
        }
        else{
            let tokenArray = self.fetchToken(nil)
            let address = tokenArray[index!].value(forKey: "address") as! String
            let name = tokenArray[index!].value(forKey: "name") as! String
            let symbol = tokenArray[index!].value(forKey: "symbol") as! String
            let decimals = tokenArray[index!].value(forKey: "decimals") as! Int
            let network = tokenArray[index!].value(forKey: "network") as! String
            var logo = tokenArray[index!].value(forKey: "logo") as? Data
            if(logo == nil){logo = "".data(using: .utf8)!}       //temporary
            let tokenSelect = CustomToken(name: name, symbol: symbol, address: address, decimals: decimals, network: network, logo: logo)
            self.token = tokenSelect
        }
        _setGasForToken()
    }

    func setToken(token: CustomToken) {
        self.token = token
        _setGasForToken()
    }

    func checkTokenExists(address: String) -> Bool{
        let addressPredicate = NSPredicate(format: "address = %@", address)
        let tokenArray = self.fetchToken(addressPredicate)

        return tokenArray.count != 0
    }

    func attachTokenObserver(_ observer: TokenObserver){
        observers.append(observer)
    }

    func getTokenInfo(address: String) throws -> CustomToken {
        guard let _ = EthereumAddress(address) else {throw GetTokenError.invalidAddress}
        if(self.checkTokenExists(address: address)){ throw GetTokenError.existingToken }

        do{
            let web3 = CustomWeb3.web3
            let token = web3.getWeb3Ins()!.contract(Web3Utils.erc20ABI, at: EthereumAddress(address)!)
            let option = web3.getOption()

            let name = try token!.method("name", transactionOptions: option)?.call()["0"] as! String
            if(name.count == 0){ throw GetTokenError.tokenNil }

            var symbol = try token!.method("symbol", transactionOptions: option)?.call()["0"] as! String
            symbol = symbol.onlyAlphabet()

            var decimals = try token!.method("decimals", transactionOptions: option)?.call()["0"] as? BigUInt
            if(decimals == nil) {decimals = BigUInt(0)}

            let erc20 = CustomToken(name: name, symbol: symbol, address: address, decimals: Int(decimals!.description)!, network: self._network!.name, logo: nil)

            return erc20
        }catch{
            throw error
        }
    }

    func getTokenBalance(address: EthereumAddress) -> BigUInt{
        let web3 = CustomWeb3.web3
        var option = web3.getOption()!
        let contract = web3.getWeb3Ins()!.contract(Web3Utils.erc20ABI, at: EthereumAddress(token!.address)!)
        option.from = address

        let balance = try! contract?.method("balanceOf", parameters: [address] as [AnyObject], transactionOptions: option)?.call()["0"] as! BigUInt

        return balance
    }

    func detachTokenObserver(_ delObserver: TokenObserver){
        guard let index = self.observers.firstIndex(where: { $0.id == delObserver.id }) else {
            return
        }
        self.observers.remove(at: index)
    }

    func networkChanged(network: CustomWeb3Network) {
        _saveTokenSelected()
        self._network = network
        _loadTokenSelected()
    }

    private func notify(){
        for observer in observers {
            observer.tokenChanged(token: self.token)
        }
    }

    private func _setGasForToken(){
        let web3: CustomWeb3 = CustomWeb3.web3
        let getGas = web3.getGas()!
        if(getGas.rate == "custom"){
            web3.setGas(price: getGas.price!, limit: getGas.limit!)
        }
        else{
            web3.setGas(rate: getGas.rate)
        }
    }

    private func _deleteTokenSelected() {
        let name = _network!.name
        userDefaults.removeObject(forKey: "network_"+name+"_token")
    }

    private func _saveTokenSelected() {
        let name = _network!.name
        do{
            userDefaults.set(try PropertyListEncoder().encode(token), forKey:"network_"+name+"_token")
        }
        catch{

        }
    }

    private func _loadTokenSelected(){
        let name = _network!.name
        guard let rawArray = UserDefaults.standard.value(forKey:"network_"+name+"_token") as? Data else {
            self.token = nil
            return
        }
        let token = try! PropertyListDecoder().decode(CustomToken.self, from: rawArray)
        self.token = token
    }
}
