//
// Created by 김경인 on 2019-07-26.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class CustomWeb3 {

    private let _web3Main = Web3.InfuraMainnetWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Robsten = Web3.InfuraRopstenWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Rinkeby = Web3.InfuraRinkebyWeb3(accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private var _customNetwork: [CustomWeb3Network] = [CustomWeb3Network]()
    private var _option: TransactionOptions?
    private var _web3Ins: web3?
    private var _network: CustomWeb3Network?
    private var observers: [NetworkObserver] = [NetworkObserver]()

    let account: EthAccount = EthAccount.accountInstance
    let userDefaults = UserDefaults.standard

    static let web3 = CustomWeb3()

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
        setOption()
        _loadNetwork()
        _loadNetworkArray()
        if (network == nil || network!.name == "mainnet" || network!.name == "robsten" ||  network!.name == "rinkeby") {
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

    func addToken(token: CustomToken){

    }

    func addToken(name: String, symbol: String, address: String, decimals: UInt8){

    }

    func getTokenInfo(address: String) throws -> CustomToken {
        guard let address = EthereumAddress(address) else {throw GetTokenError.invalidAddress}
        if(account.checkToken(address: address)){ throw GetTokenError.existingToken }

        do{
            let token = _web3Ins!.contract(Web3Utils.erc20ABI, at: address)

            let name = try token!.method("name", transactionOptions: _option)?.call()["0"] as! String
            if(name.count == 0){ throw GetTokenError.tokenNil }

            var symbol = try token!.method("symbol", transactionOptions: _option)?.call()["0"] as! String
            symbol = symbol.onlyAlphabet()

            var decimals = try token!.method("decimals", transactionOptions: _option)?.call()["0"] as? BigUInt
            if(decimals == nil) {decimals = BigUInt(0)}

            let erc20 = CustomToken(name: name, symbol: symbol, address: address, decimals: decimals!, logo: nil)

            return erc20
        }catch{
            throw error
        }
    }

    func getWeb3Ins() -> web3? {
        return _web3Ins
    }

    func getBalance(address: String?, completion: @escaping (BigUInt?) -> ()) {
        var addressModified: EthereumAddress?
        if (address == nil) {
            addressModified = _getAddress()
        } else {
            addressModified = EthereumAddress(address!)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let token = self.account.getToken()
            do {
                if (addressModified == nil) {
                    completion(nil)
                } else {
                    if(token == nil){
                        let balance = try self._web3Ins?.eth.getBalance(address: addressModified!)
                        completion(balance)
                    }
                    else{
                        let balance = self.getTokenBalance(token: token!)
                        completion(balance)
                    }
                }
            } catch {
                print(error)
                completion(nil)
            }
        }
    }

    func getTokenBalance(token: CustomToken) -> BigUInt{
        let contract = _web3Ins?.contract(Web3Utils.erc20ABI, at: token.address)
        let from = _getAddress()
        _option!.from = from

        let balance = try! contract?.method("balanceOf", parameters: [from] as [AnyObject], transactionOptions: _option)?.call()["0"] as! BigUInt

        return balance
    }

    func transfer(address: String, amount: BigUInt) {
        _transfer(address: EthereumAddress(address)!, amount: amount)
    }

    func transferToken(token: EthereumAddress, address: String, amount: BigUInt){
        _transferToken(token: token, address: EthereumAddress(address)!, amount: amount)
    }

    func preTransfer(address: String, amount: String) throws {
        if(amount.count == 0){ throw TransferError.invalidAmount}
        guard let address = EthereumAddress(address) else { throw TransferError.invalidAddress }
        if(Web3Utils.parseToBigUInt(amount, decimals: 18) == nil){ throw TransferError.invalidAmount}
        if(address == _getAddress()){ throw TransferError.transferToSelf}
    }

    func setNetwork(network: CustomWeb3Network?) {
        switch (network?.name) {
        case "mainnet":
            _web3Ins = _web3Main
            self.network = network
            break
        case "robsten":
            _web3Ins = _web3Robsten
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
        }
        do{
            let newWeb3 = try Web3.new(network.url)
            _web3Ins = newWeb3
            if(new){
                _addNetwork(network: network)
                self.network = network
            }
        }catch{
            throw AddNetworkError.invalidNetwork
        }
    }

    func getNetworks() -> [CustomWeb3Network] {
        var networks: [CustomWeb3Network] = [
            CustomWeb3Network(name: "mainnet", url: URL(string: "https://api.infura.io/v1/jsonrpc/mainnet")!),
            CustomWeb3Network(name: "robsten", url: URL(string: "https://api.infura.io/v1/jsonrpc/robsten")!),
            CustomWeb3Network(name: "rinkeby", url: URL(string: "https://api.infura.io/v1/jsonrpc/rinkeby")!)    
        ]
        networks.append(contentsOf: _customNetwork)

        return networks
    }

    func delNetwork(network: CustomWeb3Network){
        if(network == network){
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
        switch (rate) {
        case "low":
            _option!.gasLimit = TransactionOptions.GasLimitPolicy.manual(BigUInt(21000))
            _option!.gasPrice = TransactionOptions.GasPricePolicy.manual(BigUInt(1000000000 * 4))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 4), limit: BigUInt(21000))
            break
        case "mid":
            _option!.gasLimit = TransactionOptions.GasLimitPolicy.manual(BigUInt(21000))
            _option!.gasPrice = TransactionOptions.GasPricePolicy.manual(BigUInt(1000000000 * 10))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 10), limit: BigUInt(21000))
            break
        case "high":
            _option!.gasLimit = TransactionOptions.GasLimitPolicy.manual(BigUInt(21000))
            _option!.gasPrice = TransactionOptions.GasPricePolicy.manual(BigUInt(1000000000 * 20))
            gas = CustomGas(rate: rate, price: BigUInt(1000000000 * 20), limit: BigUInt(21000))
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
        _option!.gasLimit = TransactionOptions.GasLimitPolicy.manual(price)
        _option!.gasPrice = TransactionOptions.GasPricePolicy.manual(limit)

        let gas = CustomGas(rate: "custom", price: price, limit: limit)
        _saveGas(gas: gas)
    }

    func getGas() -> CustomGas? {
        return _loadGas()
    }

    func getGasInWei() -> BigUInt {
        let gas = _loadGas()!
        return gas.price! * gas.limit!
    }

    func getOption() -> TransactionOptions? {
        return _option
    }

    func setOption() {
        _option = TransactionOptions.defaultOptions
        guard let gas = _loadGas() else {
            setGas(rate: "mid")
            return
        }

        if (gas.rate != "custom") {
            setGas(rate: gas.rate)
        } else {
            setGas(price: gas.price!, limit: gas.limit!)
        }
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

    private func _getAddress() -> EthereumAddress? {
        return account.getAddress()
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
        if(name == "mainnet" || name == "robsten" ||  name == "rinkeby"){
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

    private func _transfer(address: EthereumAddress, amount: BigUInt){
        let from = _getAddress()
        var keystoreManager: KeystoreManager!
        if(account.checkPrivate(checkAddress: from!.address)){
            keystoreManager = _getPlainKeystoreManager()!
        }
        else{
            keystoreManager = _getKeyStoreManager()!
        }

        _web3Ins!.addKeystoreManager(keystoreManager)
        _option!.from = _getAddress()

        DispatchQueue.global(qos: .userInitiated).async{
            do{
                let intermediateTX =  self._web3Ins!.eth.sendETH(to: address, amount: amount, transactionOptions: self._option)
                let keyHex =  KeychainService.loadPassword(service: "moahWallet", account: "password")!
                let txHash = try intermediateTX?.send(password: keyHex)
                print(txHash)
            }
            catch{
                print(error)
            }
        }
    }

    private func _transferToken(token: EthereumAddress, address: EthereumAddress, amount: BigUInt){
        let keystoreManager = _getKeyStoreManager()!
        let from = _getAddress()!
        _web3Ins?.addKeystoreManager(keystoreManager)
        _option!.from = from

        DispatchQueue.global(qos: .userInitiated).async{
            do{
                /*
                let keyHex =  KeychainService.loadPassword(service: "moahWallet", account: "password")!
                let token = ERC20(address, from: from, password: keyHex)
                token.options = self._option!
                let intermediateTX = try token.transfer(to: address, amount: amount)
                print(intermediateTX)*/
            }
            catch{
                print(error)
            }
        }
    }

}
