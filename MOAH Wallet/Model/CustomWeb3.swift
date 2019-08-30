//
// Created by 김경인 on 2019-07-26.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import BigInt
import PromiseKit
import CoreData

class CustomWeb3: AddressObserver {

    private let _web3Main = Web3.InfuraMainnetWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Ropsten = Web3.InfuraRopstenWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Rinkeby = Web3.InfuraRinkebyWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private var _customNetwork: [CustomWeb3Network] = [CustomWeb3Network]()
    private var _option: TransactionOptions?
    private var _web3Ins: web3?
    private var _network: CustomWeb3Network?
    private var _address: CustomAddress?
    private var observers: [NetworkObserver] = [NetworkObserver]()
    private var socketProvider2: WebsocketProvider?
    private var socketProvider: InfuraWebsocketProvider?
    private var httpProvider: Web3HttpProvider?
    var id: String = "CustomWeb3"
    let account: EthAccount = EthAccount.shared
    let userDefaults = UserDefaults.standard

    static let shared = CustomWeb3()

    var network: CustomWeb3Network? {
        set(value){
            _network = value
            _saveNetwork()
            notify()
        }
        get{
            return _network
        }
    }

    private init() {
        let ethAddress: EthAddress = EthAddress.address
        self._address = ethAddress.address
        ethAddress.attachAddressObserver(self)
        _loadNetwork()
        _loadNetworkArray()
        if (network == nil || network!.name == "mainnet" || network!.name == "ropsten" ||  network!.name == "rinkeby") {
            setNetwork(network: network)
        } else {
            for network in _customNetwork {
                if (network == self.network!) {
                    do{
                        try setNetwork(network: self.network!, new: false)
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
    }

    func getWeb3Ins() -> web3? {
        return _web3Ins
    }

    func getBalance(address: String?, completion: @escaping (BigUInt?, BigUInt?) -> ()) {
        var addressModified: EthereumAddress?
        if (address == nil) {
            addressModified = EthereumAddress(_address!.address)!
        } else {
            addressModified = EthereumAddress(address!)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let ethToken = EthToken.shared
            let token = ethToken.token
            do {
                if (addressModified == nil) {
                    completion(nil, nil)
                } else {
                    let ethBalance = try self._web3Ins?.eth.getBalance(address: addressModified!)
                    if(token != nil){
                        let tokenBalance = ethToken.getTokenBalance(address: addressModified!)
                        completion(ethBalance, tokenBalance)
                    }else{
                        completion(ethBalance, nil)
                    }
                }
            } catch {
                print(error)
                completion(nil, nil)
            }
        }
    }

    func getBalanceSync(address: String?, completion: @escaping (BigUInt?) -> ()) {
        var addressModified: EthereumAddress?
        if (address == nil) {
            addressModified = EthereumAddress(_address!.address)!
        } else {
            addressModified = EthereumAddress(address!)
        }

        let ethToken = EthToken.shared
        let token = ethToken.token

        do {
            if (addressModified == nil) {
                completion(nil)
            } else {
                if(token == nil){
                    let balance = try self._web3Ins?.eth.getBalance(address: addressModified!)
                    completion(balance)
                }
                else{
                    let balance = ethToken.getTokenBalance(address: addressModified!)
                    completion(balance)
                }
            }
        } catch {
            print(error)
            completion(nil)
        }
    }

    func transfer(tx: WriteTransaction, subInfo: TXSubInfo){
        _transfer(tx: tx, subInfo: subInfo)
    }

    func preTransfer(address: String, amount: String, completion: @escaping (WriteTransaction?, BigUInt?, TXSubInfo?, String?) -> ()) throws {
        if(amount.count == 0){ throw TransferError.invalidAmount}
        if(address == _address!.address){ throw TransferError.transferToSelf}
        guard let address = EthereumAddress(address) else { throw TransferError.invalidAddress }
        if(Web3Utils.parseToBigUInt(amount, decimals: 18) == nil){ throw TransferError.invalidAmount}

        DispatchQueue.global(qos: .userInteractive).async{
            do{
                let ethToken = EthToken.shared
                let token = ethToken.token
                let from = self._address!.address
                let auto = self.getGasInWei() == nil
                let gas = self.getGas()
                var gasPrice = gas?.price
                var gasLimit = gas?.limit

                self._option!.from = EthereumAddress(from)!
                if(token == nil){
                    let amount = Web3Utils.parseToBigUInt(amount, decimals: 18)!
                    if let tx =  self._web3Ins!.eth.sendETH(to: address, amount: amount, transactionOptions: self._option){
                        if(auto){
                            gasLimit = try self._web3Ins!.eth.estimateGas(tx.transaction, transactionOptions: self._option!)
                            gasPrice = try self._web3Ins?.eth.getGasPrice()
                        }


                        let subInfo = TXSubInfo(to: address.address, from: from, category: "Ether Transfer",
                                amount: amount, symbol: "ETH", decimals: 18, gasPrice: gasPrice!, gasLimit: gasLimit!)
                        completion(tx, gasLimit!*gasPrice!, subInfo, nil)
                    }
                    else{
                        completion(nil, nil, nil, nil)
                    }

                }else{
                    let tokenAddress = EthereumAddress(token!.address)!
                    let amount = Web3Utils.parseToBigUInt(amount, decimals: Int(token!.decimals.description)!)!

                    let tokenContract = self._web3Ins!.contract(Web3Utils.erc20ABI, at: tokenAddress)
                    if let tx = tokenContract!.write("transfer", parameters: [address, amount] as [AnyObject],
                            extraData: Data(), transactionOptions: self._option){

                        if(auto){
                            gasLimit = try self._web3Ins!.eth.estimateGas(tx.transaction, transactionOptions: self._option!)
                            gasPrice = try self._web3Ins?.eth.getGasPrice()
                        }

                        let subInfo = TXSubInfo(to: address.address, from: from, category: "Token Transfer",
                                amount: amount, symbol: token!.symbol, decimals: Int(token!.decimals.description)!,
                                gasPrice: gasPrice!, gasLimit: gasLimit!)

                        completion(tx, gasLimit!*gasPrice!, subInfo, nil)
                    }
                    else{
                        completion(nil, nil, nil, nil)
                    }
                }
            }
            catch Web3Error.nodeError(let desc){
                print(desc)
                if(desc.contains("gas")){
                    completion(nil, nil, nil, "gas")    
                }
                else if(desc.contains("address")){
                    completion(nil, nil, nil, "address")
                }
            }
            catch{
                print(error)
                completion(nil, nil, nil, "unknown")
            }
        }
    }

    func setNetwork(network: CustomWeb3Network?) {
        switch (network?.name) {
        case "mainnet":
            _web3Ins = _web3Main
            self.network = network
            break
        case "ropsten":
            _web3Ins = _web3Ropsten
            self.network = network
            break
        case "rinkeby":
            _web3Ins = _web3Rinkeby
            self.network = network
            break
        default:
            _web3Ins = _web3Main
            self.network = CustomWeb3Network(name: "mainnet", url: URL(string: "https://api.infura.io/v1/jsonrpc/mainnet")!)
            break
        }
    }

    func setNetwork(network: CustomWeb3Network, new: Bool) throws {
        if(new){
            if(!_checkNetwork(name: network.name)){
                throw AddNetworkError.invalidName
            }
            if(network.name.contains("private_key")){
                throw AddNetworkError.invalidName
            }
        }
        do{
            let newWeb3 = try Web3.new(network.url)
            _web3Ins = newWeb3
            self.network = network

            if(new){
                _addNetwork(network: network)
            }
        }catch{
            throw AddNetworkError.invalidNetwork
        }
    }

    func getNetworks() -> [CustomWeb3Network] {
        var networks: [CustomWeb3Network] = [
            CustomWeb3Network(name: "mainnet", url: URL(string: "https://api.infura.io/v1/jsonrpc/mainnet")!),
            CustomWeb3Network(name: "ropsten", url: URL(string: "https://api.infura.io/v1/jsonrpc/ropsten")!),
            CustomWeb3Network(name: "rinkeby", url: URL(string: "https://api.infura.io/v1/jsonrpc/rinkeby")!)    
        ]
        networks.append(contentsOf: _customNetwork)

        return networks
    }

    func delNetwork(network: CustomWeb3Network){
        if(network == self.network!){
            setNetwork(network: CustomWeb3Network(name: "mainnet", url: URL(string: "https://api.infura.io/v1/jsonrpc/mainnet")!))
        }
        let index = _customNetwork.firstIndex(where: {$0 == network})
        _customNetwork.remove(at: index!)
        _saveNetworkArray()
    }

    func setGas(rate: String) {
        if (_option == nil) {
            return
        }
        var gas: CustomGas!
        var gasLimit: BigUInt!
        let ethToken = EthToken.shared
        let isToken = ethToken.token != nil

        if(isToken){
            gasLimit = BigUInt(100000)
        }
        else{
            gasLimit = BigUInt(21000)
        }
        switch (rate) {
        case "low":
            _option!.gasLimit = .manual(gasLimit)
            _option!.gasPrice = .manual(BigUInt(1000000000 * 4))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 4), limit: gasLimit)
            break
        case "mid":
            _option!.gasLimit = .manual(gasLimit)
            _option!.gasPrice = .manual(BigUInt(1000000000 * 10))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 10), limit: gasLimit)
            break
        case "high":
            _option!.gasLimit = .manual(gasLimit)
            _option!.gasPrice = .manual(BigUInt(1000000000 * 20))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 20), limit: gasLimit)
            break
        case "auto":
            _option!.gasLimit = .automatic
            _option!.gasPrice = .automatic
            gas = CustomGas(rate: rate, price: nil, limit: nil)
            break
        default:
            break
        }
        _saveGas(gas: gas)
    }

    func setGas(price: BigUInt, limit: BigUInt) {
        if (_option == nil) {
            return
        }
        _option!.gasPrice = .manual(price)
        _option!.gasLimit = .manual(limit)

        let gas = CustomGas(rate: "custom", price: price, limit: limit)
        _saveGas(gas: gas)
    }

    func getGas() -> CustomGas? {
        return _loadGas()
    }

    func getGasInWei() -> BigUInt? {
        let gas = _loadGas()!
        guard let price = gas.price else {return nil}

        return price * gas.limit!
    }

    func getOption() -> TransactionOptions? {
        return _option
    }

    func setOption() {
        _option = TransactionOptions.defaultOptions
        guard let gas = _loadGas() else {
            setGas(rate: "auto")
            return
        }

        if (gas.rate != "custom") {
            setGas(rate: gas.rate)
        } else {
            setGas(price: gas.price!, limit: gas.limit!)
        }
    }

    func getTXReceipt(hash: String) -> TransactionReceipt? {
        if(_web3Ins == nil) { return nil }
        var tx: TransactionReceipt?
        do{
            tx = try _web3Ins!.eth.getTransactionReceipt(hash)
        }
        catch{
            print(error)
        }
        return tx
    }

    func getTXDetail(hash: String) -> TransactionDetails? {
        if(_web3Ins == nil) { return nil }
        var tx: TransactionDetails?
        do{
            tx = try _web3Ins!.eth.getTransactionDetails(hash)
        }
        catch{
            print(error)
        }
        return tx
    }

    func attachNetworkObserver(_ observer: NetworkObserver){
        observers.append(observer)
    }

    func detachNetworkObserver(_ delObserver: NetworkObserver){
        guard let index = self.observers.firstIndex(where: { $0.id == delObserver.id }) else {
            return
        }
        self.observers.remove(at: index)
    }

    func addressChanged(address: CustomAddress) {
        self._address = address
    }

    private func notify(){
        for observer in observers {
            observer.networkChanged(network: self.network!)
        }
    }

    private func _getKeyStoreManager() -> KeystoreManager? {
        return account.getKeyStoreManager()
    }

    private func _getPlainKeystoreManager() -> KeystoreManager? {
        return account.getPlainKeyStoreManager()
    }

    private func _loadGas() -> CustomGas? {
        guard let rawGas = userDefaults.value(forKey: "gas") as? Data else {
            return nil
        }

        let gas = try! PropertyListDecoder().decode(CustomGas.self, from: rawGas)
        return gas
    }

    private func _saveGas(gas: CustomGas) {
        userDefaults.set(try! PropertyListEncoder().encode(gas), forKey: "gas")
    }

    private func _loadNetwork(){
        if let rawArray = UserDefaults.standard.value(forKey:"network") as? Data {
            let network = try! PropertyListDecoder().decode(CustomWeb3Network.self, from: rawArray)
            self.network = network
        }
        else{
            return
        }
    }

    private func _saveNetwork() {
        userDefaults.set(try! PropertyListEncoder().encode(network), forKey:"network")
    }

    private func _addNetwork(network: CustomWeb3Network) {
        _customNetwork.append(network)
        _saveNetworkArray()
    }

    private func _checkNetwork(name: String) -> Bool {
        if(name == "mainnet" || name == "ropsten" ||  name == "rinkeby"){
            return false
        }
        for network in _customNetwork{
            if(name == network.name){
                return false
            }
        }
        return true
    }
    private func _loadNetworkArray() {
        guard let network = userDefaults.value(forKey: "customNetwork") as? Data else {
            return
        }
        _customNetwork = try! PropertyListDecoder().decode([CustomWeb3Network].self, from: network)
    }

    private func _saveNetworkArray() {
        userDefaults.set(try! PropertyListEncoder().encode(_customNetwork), forKey: "customNetwork")
    }


    private func _transfer(tx: WriteTransaction?, subInfo: TXSubInfo){
        let ethAddress: EthAddress = EthAddress.address
        var keystoreManager: KeystoreManager!

        if(ethAddress.checkPrivate(self._address!.address)){
            keystoreManager = _getPlainKeystoreManager()!
        }
        else{
            keystoreManager = _getKeyStoreManager()!
        }
        _web3Ins?.addKeystoreManager(keystoreManager)

        DispatchQueue.global(qos: .userInitiated).async{
            do{
                let keyHex =  KeychainService.loadPassword(service: "moahWallet", account: "password")!
                if(tx == nil){throw TransferError.gasError}
                let txHash = try tx!.send(password: keyHex)
                self._saveTxResult(tx: txHash, subInfo: subInfo)
            }
            catch Web3Error.nodeError(let desc) {
                self._saveTxResult(error: desc, subInfo: subInfo)
            }
            catch Web3Error.processingError(let desc) {
                self._saveTxResult(error: desc, subInfo: subInfo)
            }
            catch{
                print(error)
                self._saveTxResult(error: "Unknown Error".localized, subInfo: subInfo)
            }
        }
    }

    private func _saveTxResult(tx: TransactionSendingResult, subInfo: TXSubInfo){
        let txHistory = EthTXHistory()
        txHistory.initTXInfo(tx: tx.hash, error: "", subInfo: subInfo)
    }

    private func _saveTxResult(error: String, subInfo: TXSubInfo){
        let txHistory = EthTXHistory()
        txHistory.initTXInfo(tx: "", error: error, subInfo: subInfo)
    }
}
