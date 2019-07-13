//
// Created by 김경인 on 2019-07-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import CryptoSwift


class EthAccount {

    static let accountInstance = EthAccount()

    let util = Util()
    let userDefaults = UserDefaults.standard

    private var _keyStoreManager: KeystoreManager?
    private var _mnemonic: Mnemonics?
    private var _password: String?
    private var _isVerified: Bool = false
    private var _timer: Timer?
    private init() {
    }

    func bioProceed(){
        _unlockAccount()
    }

    func savePassword(_ password: String){
        let passwordArray: [UInt8] = Array(password.utf8)
        let hash = util.randomString(length: 32)
        let salt: [UInt8] = Array(hash.utf8)

        let key = _hashPassword(password: passwordArray, salt: salt)
        let keyHex = key.toHexString()
        _password = keyHex

        userDefaults.set(hash, forKey: "salt")
        if (!KeychainService.savePassword(service: "moahWallet", account: "password", data: keyHex)) {
            KeychainService.updatePassword(service: "moahWallet", account: "password", data: keyHex)
        }
    }

    func checkPassword(_ password: String) -> Bool{
        let passwordArray: [UInt8] = Array(password.utf8)
        let hash = userDefaults.string(forKey: "salt")!
        let salt: [UInt8] = Array(hash.utf8)

        let passwordHashed = _hashPassword(password: passwordArray, salt: salt)

        let keyHex = KeychainService.loadPassword(service: "moahWallet", account: "password")!
        let key = Array<UInt8>(hex: keyHex)

        if(passwordHashed == key){
            self._password = keyHex
            _loadKeyStoreManager(password: keyHex)
            return true
        }
        else{
            return false
        }
    }

    func getKeyStoreManager() -> KeystoreManager? {
        return _keyStoreManager
    }

    func lockAccount(){
        _timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(_nilKeyData(_:)), userInfo: nil, repeats: false)
    }

    func invalidateTimer(){
        _timer?.invalidate()
        _timer = nil
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

    func getMnemonic(password: String) -> String? {
        let mnemonic = _decryptMnemonic(password: password)

        return mnemonic
    }

    func setAccount() -> Bool {
        _encryptMnemonic(password: _password!)
        _saveKeyStoreManager(password: _password!)
        _nilMnemonic()
        _unlockAccount()

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
        let key256 = Array<UInt8>(hex: password)
        let iv: [UInt8] = Array(util.randomString(length: 16).utf8)
        let aes = try! AES(key: key256, blockMode: CBC(iv: iv))
        let mnemonicEncrypted = try! aes.encrypt([UInt8](mnemonicData))

        _saveMnemonic(mnemonicEncrypted: mnemonicEncrypted)
        _saveIv(iv: iv)
    }

    private func _decryptMnemonic(password: String) -> String? {
        if(checkPassword(password)){
            let key256 = Array<UInt8>(hex: self._password!)
            let iv = _loadIv()
            let mnemonicEncrypted = _loadMnemonic()

            let aes = try! AES(key: key256, blockMode: CBC(iv: iv))
            let mnemonicDecrypted = try! aes.decrypt(mnemonicEncrypted)
            let mnemonic = String(bytes: mnemonicDecrypted, encoding: .utf8)!

            return mnemonic
        }
        else{
            return nil
        }
    }

    private func _saveMnemonic(mnemonicEncrypted: [UInt8]) {
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

    func _setPassword(_ password: String) {
        _password = password
    }

    private func _hashPassword(password: [UInt8], salt: [UInt8]) -> [UInt8]{
        let hash = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        return hash
    }

    private func _nilMnemonic(){
        _mnemonic = nil
    }

    private func _unlockAccount() {
        let keyHex = KeychainService.loadPassword(service: "moahWallet", account: "password")!
        self._password = keyHex
        _loadKeyStoreManager(password: keyHex)
    }

    @objc private func _nilKeyData(_ sender: Timer){
        _password = nil
        _keyStoreManager = nil
    }
}