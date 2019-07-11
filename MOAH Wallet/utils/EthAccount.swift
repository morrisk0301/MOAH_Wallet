//
// Created by 김경인 on 2019-07-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import CryptoSwift


class EthAccount {

    static let accountInstance = EthAccount()

    private var _keyStoreManager: KeystoreManager?
    private var _mnemonic: Mnemonics?
    private var _password: String?
    private var _isVerified: Bool = false

    private init() {
    }

    func getKeyStoreManager() -> KeystoreManager? {
        return _keyStoreManager
    }

    func lockAccount(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            //print(1231231231223)
            self._nilKeyStore()
        })
    }

    func unlockAccount(_ password: String) {
        _loadKeyStoreManager(password: password)
    }


    func setPassword(_ password: String) {
        _password = password
    }

    func generateMnemonic() -> String {
        let mnemonicSize = EntropySize(rawValue: 128)
        let mnemonic = Mnemonics(entropySize: mnemonicSize!)
        _mnemonic = mnemonic

        return mnemonic.string
    }

    func setMnemonic(mnemonicString: String) -> Bool {
        do {
            let mnemonic = try Mnemonics(mnemonicString)
            _mnemonic = mnemonic
            return true
        } catch {
            return false
        }
    }

    func verifyMnemonic(index: Int, word: String) -> Bool {
        if (_mnemonic == nil) {
            return false
        }
        let mnemonicIns = _mnemonic!.string.components(separatedBy: " ")

        if (mnemonicIns[index] == word) {
            if (index == mnemonicIns.count - 1) {
                _isVerified = true
            }
            return true
        } else {
            return false
        }
    }

    func getMnemonic(password: String) -> String {
        let mnemonic = _decryptMnemonic(password: password)

        return mnemonic
    }

    func setAccount(_ password: String) -> Bool {
        _encryptMnemonic(password: password)
        _saveKeyStoreManager(password: password)
        _nilPasswordMnemonic()
        unlockAccount(password)

        return true
    }

    func setAccount(_ isNew: Bool) -> Bool {
        _encryptMnemonic(password: _password!)
        _saveKeyStoreManager(password: _password!)
        _nilPasswordMnemonic()
        unlockAccount(_password!)

        return true
    }

    func generateAccount() {

    }

    func getIsVerified() -> Bool {
        return _isVerified
    }

    private func _encryptMnemonic(password: String) {
        let util = Util()
        let mnemonicData: Data = _mnemonic!.string.data(using: String.Encoding.utf8)!
        let key256 = [UInt8](password.data(using: String.Encoding.utf8)!.sha256)
        let iv: [UInt8] = Array(util.randomString(length: 16).utf8)
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

    private func _saveMnemonic(mnemonicEncrypted: [UInt8]) {
        let userDefaults = UserDefaults.standard
        let mnemonicEncryptedData = Data(bytes: mnemonicEncrypted, count: mnemonicEncrypted.count)

        userDefaults.set(mnemonicEncryptedData, forKey: "mnemonic")
    }

    private func _loadMnemonic() -> [UInt8] {
        let userDefaults = UserDefaults.standard
        let mnemonicEncryptedData = userDefaults.data(forKey: "mnemonic")!
        let mnemonicEncrypted = [UInt8](mnemonicEncryptedData)

        return mnemonicEncrypted
    }

    private func _saveIv(iv: [UInt8]) {
        let ivString = String(bytes: iv, encoding: .utf8)!
        if (!KeychainService.savePassword(service: "moahWallet", account: "iv", data: ivString)) {
            KeychainService.updatePassword(service: "moahWallet", account: "iv", data: ivString)
        }
    }

    private func _loadIv() -> [UInt8] {
        let ivString = KeychainService.loadPassword(service: "moahWallet", account: "iv")
        let iv: [UInt8] = Array(ivString!.utf8)

        return iv
    }

    private func _saveKeyStoreManager(password: String) {
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let keyStore = try! BIP32Keystore(mnemonics: _mnemonic!, password: password)
        let keyData = try! JSONEncoder().encode(keyStore.keystoreParams)
        FileManager.default.createFile(atPath: userDir + "/keystore" + "/key.json", contents: keyData, attributes: nil)
    }

    private func _loadKeyStoreManager(password: String) {
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        _keyStoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
    }

    private func _nilPasswordMnemonic(){
        _password = nil
        _mnemonic = nil
    }

    private func _nilKeyStore(){
        _keyStoreManager = nil
    }
}