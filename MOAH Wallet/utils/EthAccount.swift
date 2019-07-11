//
// Created by 김경인 on 2019-07-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import CryptoSwift


class EthAccount {


    static let accountInstance = EthAccount()

    private var _KEYSTORE: BIP32Keystore?
    private var _MNEMONIC: Mnemonics?
    private var isVerified: Bool = false

    private init(){}

    func generateMnemonic() -> String {
        let mnemonicSize = EntropySize(rawValue: 128)
        let mnemonic = Mnemonics(entropySize: mnemonicSize!)
        _MNEMONIC = mnemonic

        return mnemonic.string
    }

    func setMnemonic(mnemonicString: String) -> Bool {
        do{
            let mnemonic = try Mnemonics(mnemonicString)
            _MNEMONIC = mnemonic
            return true
        } catch{
            return false
        }
    }

    func setAccount(password: String) -> Bool {
        _encryptMnemonic(password: password)
        _generateKeyStore(password: password)

        return true
    }

    func verifyMnemonic(index: Int, word: String) -> Bool {
        if(_MNEMONIC == nil){ return false}
        let mnemonicIns = _MNEMONIC!.string.components(separatedBy: " ")

        if(mnemonicIns[index] == word){
            if(index == mnemonicIns.count-1){
                isVerified = true
            }
            return true
        }
        else{
            return false
        }
    }


    func generateAccount() {

    }

    func getMnemonic(password: String) -> String {
        let mnemonic = _decryptMnemonic(password: password)

        return mnemonic
    }

    func getIsVerified() -> Bool {
        return isVerified
    }

    private func _randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        return String((0..<length).map { _ in
            letters.randomElement()!
        })
    }

    private func _encryptMnemonic(password: String) {
        let mnemonicData: Data = _MNEMONIC!.string.data(using: String.Encoding.utf8)!
        let key256 = [UInt8](password.data(using: String.Encoding.utf8)!.sha256)
        let iv: [UInt8] = Array(_randomString(length: 16).utf8)
        let aes = try! AES(key: key256, blockMode: CBC(iv: iv))
        let mnemonicEncrypted = try! aes.encrypt([UInt8](mnemonicData))

        _saveMnemonic(mnemonicEncrypted: mnemonicEncrypted)
        _saveIv(iv: iv)
    }

    private func _decryptMnemonic(password: String) -> String {
        let password = [UInt8](password.data(using: String.Encoding.utf8)!.sha256)
        let iv = _loadIv()
        let mnemonicEncrypted = _loadMnemonic()

        let aes = try! AES(key: password, blockMode: CBC(iv: iv))
        let mnemonicDecrypted = try! aes.decrypt(mnemonicEncrypted)
        let mnemonic = String(bytes: mnemonicDecrypted, encoding: .utf8)!

        return mnemonic
    }

    private func _saveIv(iv: [UInt8]){
        let userDefaults = UserDefaults.standard
        let ivData = Data(bytes: iv, count: iv.count)

        userDefaults.set(ivData, forKey: "iv")
    }

    private func _saveMnemonic(mnemonicEncrypted: [UInt8]){
        let userDefaults = UserDefaults.standard
        let mnemonicEncryptedData = Data(bytes: mnemonicEncrypted, count: mnemonicEncrypted.count)

        userDefaults.set(mnemonicEncryptedData, forKey: "mnemonic")
    }

    private func _loadIv() -> [UInt8] {
        let userDefaults = UserDefaults.standard
        let ivData = userDefaults.data(forKey: "iv")!
        let iv = [UInt8](ivData)

        return iv
    }

    private func _loadMnemonic() -> [UInt8] {
        let userDefaults = UserDefaults.standard
        let mnemonicEncryptedData = userDefaults.data(forKey: "mnemonic")!
        let mnemonicEncrypted = [UInt8](mnemonicEncryptedData)

        return mnemonicEncrypted
    }

    private func _generateKeyStore(password: String){
        _KEYSTORE = try! BIP32Keystore(mnemonics: _MNEMONIC!, password: password)
    }
}