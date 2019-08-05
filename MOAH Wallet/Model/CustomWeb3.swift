//
// Created by 김경인 on 2019-07-26.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class CustomWeb3 {

    private let _web3Main = Web3(infura: .mainnet, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Robsten = Web3(infura: .ropsten, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Kovan = Web3(infura: .kovan, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Rinkeby = Web3(infura: .rinkeby, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private var _customNetwork: [CustomWeb3Network] = [CustomWeb3Network]()
    private var _network: String?
    private var _option: Web3Options?
    private var _web3Ins: Web3?

    let account: EthAccount = EthAccount.accountInstance
    let userDefaults = UserDefaults.standard

    static let web3 = CustomWeb3()

    private init() {
        _setOption()
        _loadNetwork()
        _loadNetworkArray()
        if (_network == "mainnet" || _network == "robsten" || _network == "kovan" || _network == "rinkeby" || _network == nil) {
            setNetwork(network: _network)
        } else {
            for network in _customNetwork {
                if (network.name == _network!) {
                    do{
                        try setNetwork(name: _network!, url: network.url, new: false)
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
    }

    func getWeb3Ins() -> Web3? {
        return _web3Ins
    }

    func getBalance(address: String?, completion: @escaping (BigUInt?) -> ()) {
        var addressModified: Address?
        if (address == nil) {
            addressModified = _getAddress()
        } else {
            addressModified = Address(address!)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if (addressModified == nil) {
                    completion(nil)
                } else {
                    let balance = try self._web3Ins?.eth.getBalance(address: addressModified!)
                    completion(balance)
                }
            } catch {
                print(error)
                completion(nil)
            }

        }
    }

    func setNetwork(network: String?) {
        switch (network) {
        case "mainnet":
            _web3Ins = _web3Main
            _network = "mainnet"
            break
        case "robsten":
            _web3Ins = _web3Robsten
            _network = "robsten"
            break
        case "kovan":
            _web3Ins = _web3Kovan
            _network = "kovan"
            break
        case "rinkeby":
            _web3Ins = _web3Rinkeby
            _network = "rinkeby"
            break
        default:
            _web3Ins = _web3Main
            _network = "mainnet"
            break
        }
        _saveNetwork()
    }

    func setNetwork(name: String, url: URL, new: Bool) throws {
        if(new){
            if(!_checkNetwork(name: name)){
                throw AddNetworkError.invalidName
            }
        }
        guard let network = Web3(url: url) else {
            throw AddNetworkError.invalidNetwork
        }

        _network = name
        _web3Ins = network
        _saveNetwork()
        if(new){_addNetwork(name: name, url: url)}
    }

    func getNetwork() -> String {
        return _network!
    }

    func getNetworks() -> [CustomWeb3Network] {
        var networks: [CustomWeb3Network] = [
            CustomWeb3Network(name: "mainnet", url: URL(string: "https://api.infura.io/v1/jsonrpc/mainnet")!),
            CustomWeb3Network(name: "robsten", url: URL(string: "https://api.infura.io/v1/jsonrpc/robsten")!),
            CustomWeb3Network(name: "kovan", url: URL(string: "https://api.infura.io/v1/jsonrpc/kovan")!),
            CustomWeb3Network(name: "rinkeby", url: URL(string: "https://api.infura.io/v1/jsonrpc/rinkeby")!)    
        ]
        networks.append(contentsOf: _customNetwork)

        return networks
    }

    func delNetwork(name: String, url: URL){
        if(name == _network){
            setNetwork(network: "mainnet")
        }
        let index = _customNetwork.firstIndex(where: {$0.name == name && $0.url == url})
        _customNetwork.remove(at: index!)
        _saveNetworkArray()
    }

    func setGas(rate: String) {
        if (_option == nil) {
            return
        }
        switch (rate) {
        case "low":
            _option?.gasLimit = BigUInt(21000)
            _option?.gasPrice = BigUInt(1000000000 * 4)
            break
        case "mid":
            _option?.gasLimit = BigUInt(21000)
            _option?.gasPrice = BigUInt(1000000000 * 10)
            break
        case "high":
            _option?.gasLimit = BigUInt(21000)
            _option?.gasPrice = BigUInt(1000000000 * 20)
            break
        default:
            break
        }
        let gas = CustomGas(rate: rate, price: nil, limit: nil)
        _saveGas(gas: gas)
    }

    func setGas(price: BigUInt, limit: BigUInt) {
        if (_option == nil) {
            return
        }
        _option?.gasLimit = price
        _option?.gasPrice = limit

        let gas = CustomGas(rate: "custom", price: price, limit: limit)
        _saveGas(gas: gas)
    }

    func getGas() -> CustomGas? {
        return _loadGas()
    }

    func getOption() -> Web3Options? {
        return _option
    }

    private func _setOption() {
        _option = Web3Options.default
        _option?.from = _getAddress()
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


    private func _getKeyStoreManager() -> KeystoreManager? {
        return account.getKeyStoreManager()
    }

    private func _getAddress() -> Address? {
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

    private func _saveNetwork() {
        userDefaults.set(_network, forKey: "network")
    }

    private func _loadNetwork() {
        let network = userDefaults.string(forKey: "network")
        _network = network
    }

    private func _addNetwork(name: String, url: URL) {
        let network = CustomWeb3Network(name: name, url: url)
        _customNetwork.append(network)
        _saveNetworkArray()
    }

    private func _checkNetwork(name: String) -> Bool {
        if(name == "mainnet" || name == "robsten" ||  name == "kovan" || name == "rinkeby"){
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

}
