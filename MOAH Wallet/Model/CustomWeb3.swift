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
    private var _option: Web3Options?
    private var _web3Ins: Web3?

    let account: EthAccount = EthAccount.accountInstance
    let userDefaults = UserDefaults.standard

    static let web3 = CustomWeb3()

    private init() {
        setNetwork(network: nil)
        _setOption()
    }

    func getWeb3Ins() -> Web3? {
        return _web3Ins
    }

    func getBalance(address: String?, completion: @escaping (BigUInt?) -> () ){
        var addressModified: Address?
        if(address == nil){
            addressModified = _getAddress()
        }else{
            addressModified = Address(address!)
        }

        DispatchQueue.global(qos: .userInitiated).async{
            do{
                if(addressModified == nil){
                    completion(nil)
                }else{
                    let balance = try self._web3Ins?.eth.getBalance(address: addressModified!)
                    completion(balance)
                }
            }catch{
                print(error)
                completion(nil)
            }

        }
    }

    func setNetwork(network: String?){
        switch (network) {
        case "main":
            _web3Ins = _web3Main
            break
        case "robsten":
            _web3Ins = _web3Robsten
            break
        case "kovan":
            _web3Ins = _web3Kovan
            break
        case "rinkeby":
            _web3Ins = _web3Rinkeby
            break
        default:
            //_web3Ins = _web3Main
            _web3Ins = _web3Kovan
            break
        }
    }

    func setGas(rate: String){
        if(_option == nil){ return }
        switch(rate){
            case "low":
                _option?.gasLimit = BigUInt(21000)
                _option?.gasPrice = BigUInt(1000000000*4)
                break
            case "mid":
                _option?.gasLimit = BigUInt(21000)
                _option?.gasPrice = BigUInt(1000000000*10)
                break
            case "high":
                _option?.gasLimit = BigUInt(21000)
                _option?.gasPrice = BigUInt(1000000000*20)
                break
            default:
                break
        }
        let gas = CustomGas(rate: rate, price: nil, limit: nil)
        _saveGas(gas: gas)
    }

    func setGas(price: BigUInt, limit: BigUInt){
        if(_option == nil){ return }
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

    private func _setOption(){
        _option = Web3Options.default
        _option?.from = _getAddress()
        guard let gas = _loadGas() else {
            setGas(rate: "mid")
            return
        }

        if(gas.rate != "custom"){
            setGas(rate: gas.rate)
        }
        else{
            setGas(price: gas.price!, limit: gas.limit!)
        }
    }


    private func _getKeyStoreManager() -> KeystoreManager?{
        return account.getKeyStoreManager()
    }

    private func _getAddress() -> Address?{
        return account.getAddress()
    }

    private func _loadGas() -> CustomGas? {
        guard let rawGas = userDefaults.value(forKey:"gas") as? Data else { return nil }

        let gas = try! PropertyListDecoder().decode(CustomGas.self, from: rawGas)
        return gas
    }

    private func _saveGas(gas: CustomGas){
        userDefaults.set(try! PropertyListEncoder().encode(gas), forKey:"gas")   
    }

}
