//
// Created by 김경인 on 2019-07-26.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class Web3Custom {

    private let _web3Main = Web3(infura: .mainnet, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Robsten = Web3(infura: .ropsten, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Kovan = Web3(infura: .kovan, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private let _web3Rinkeby = Web3(infura: .rinkeby, accessToken: "7bdfe4d2582141ef8e00c2cf929c72ee")
    private var _web3Ins: Web3?

    static let web3 = Web3Custom()

    private init() {
        setNetwork(network: nil)
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

    private func _getKeyStoreManager() -> KeystoreManager?{
        let account: EthAccount = EthAccount.accountInstance
        return account.getKeyStoreManager()
    }

    private func _getAddress() -> Address?{
        let account: EthAccount = EthAccount.accountInstance
        return account.getAddress()
    }

}
