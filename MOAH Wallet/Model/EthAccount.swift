//
// Created by 김경인 on 2019-07-08.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import CryptoSwift
import CoreData

class EthAccount: NetworkObserver, AddressObserver{

    static let shared = EthAccount()

    let util = Util()
    let userDefaults = UserDefaults.standard
    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    var id: String = ""

    private var _keyStoreManager: KeystoreManager?
    private var _plainKeyStoreManager: KeystoreManager?
    private var _keyStore: BIP32Keystore?
    private var _plainKeystore: [PlainKeystore]?
    private var _mnemonic: String?
    private var _password: String?
    private var _isVerified: Bool = false
    private var _timer: Timer?
    private var _address: CustomAddress?
    private var _network: CustomWeb3Network?

    private init() {
    }

    func bioProceed() {
        _unlockAccount()
    }

    func changePassword(_ password: String){
        let oldPassword = _password!
        savePassword(password)
        _regenerateKeyStore(oldPassword: oldPassword, password: _password!)
        _reencryptMnemonic(oldPassword: oldPassword, password: _password!)
        _reencryptPrivateKey(oldPassword: oldPassword, password: _password!)
    }

    func savePassword(_ password: String) {
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

    func checkPassword(_ password: String) -> Bool {
        let passwordArray: [UInt8] = Array(password.utf8)
        let hash = userDefaults.string(forKey: "salt")!
        let salt: [UInt8] = Array(hash.utf8)

        let passwordHashed = _hashPassword(password: passwordArray, salt: salt)

        let keyHex = KeychainService.loadPassword(service: "moahWallet", account: "password")!
        let key = Array<UInt8>(hex: keyHex)

        if (passwordHashed == key) {
            self._password = keyHex
            _unlockAccount()
            return true
        } else {
            return false
        }
    }

    func getKeyStoreManager() -> KeystoreManager? {
        return _keyStoreManager
    }

    func getPlainKeyStoreManager() -> KeystoreManager? {
        return _plainKeyStoreManager
    }

    func lockAccount() {
        _lockKeyData()
    }

    func invalidateTimer() {
        _timer?.invalidate()
        _timer = nil
    }

    func generateMnemonic() -> String {
        let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 128)
        _mnemonic = mnemonic

        return mnemonic!
    }

    func setMnemonic(mnemonicString: String) -> Bool {
        do {
            _ = try BIP32Keystore(mnemonics: mnemonicString)
            _mnemonic = mnemonicString
            return true
        } catch {
            return false
        }
    }

    func verifyMnemonic(index: Int, word: String) -> Bool {
        if (_mnemonic == nil) {
            _mnemonic =  _loadMnemonic(password: _password!)
        }
        let mnemonicIns = _mnemonic!.components(separatedBy: " ")

        if (mnemonicIns[index] == word) {
            return true
        } else {
            return false
        }
    }

    func getMnemonic() -> String {
        let mnemonic = _loadMnemonic(password: _password!)
        return mnemonic
    }

    func getPrivateKey() -> String {
        guard let privateKey = _loadPrivateKey(name: _address!.name, password: _password!) else{
            let privateKey2 = try! _keyStore?.UNSAFE_getPrivateKeyData(password: _password!, account: EthereumAddress(_address!.address)!)

            return privateKey2!.toHexString()
        }
        return privateKey
    }

    func setAccount() -> Bool {
        _saveMnemonic(password: _password!)
        _generateKeyStore(password: _password!)
        _saveKeyStore()
        _initAccount()
        _unlockAccount()

        return true
    }

    func getAccount(key: String, name: String) throws -> Bool{
        let ethAddress: EthAddress = EthAddress.address
        guard !ethAddress.checkAddressName(name) else{ return false }
        guard let keyStore = PlainKeystore(privateKey: key) else{ throw GetAccountError.invalidPrivateKey }
        do{
            if(ethAddress.checkAddressExists(keyStore.addresses!.first!.address)){
                throw GetAccountError.existingAccount
            }

            let ethAddress: EthAddress = EthAddress.address
            let address = CustomAddress(address: keyStore.addresses!.first!.address, name: name, isPrivateKey: true, path: "")
            ethAddress.addAddress(address)
            _savePrivateKey(key: key, name: name, password: _password!)
            _loadPlainKeyStore()
        }
        catch GetAccountError.existingAccount{
            throw GetAccountError.existingAccount
        }
        catch{
            throw GetAccountError.invalidPrivateKey
        }

        return true
    }

    func generateAccount(name: String) -> Bool {
        let ethAddress: EthAddress = EthAddress.address
        guard !ethAddress.checkAddressName(name) else{ return false }
        guard !ethAddress.checkAddressCount() else{ return false }

        do {
            try _createAccount(name: name)
        } catch {
            print(error)
            return false
        }
        return true
    }

    func deleteAccount(account: CustomAddress){
        if(account.isPrivateKey){
            _delPrivateKey(name: account.name)
        }else{
            _delAddressFromPath(account: account)
        }
        let ethAddress: EthAddress = EthAddress.address

        if(account.address == _address!.address){
            ethAddress.setAddress(index: nil)
        }
        ethAddress.deleteAddress(name: account.name)
    }

    func verifyAccount(){
        _isVerified = true
        _saveIsVerified()
    }

    func getIsVerified() -> Bool {
        return _isVerified
    }

    func _setPassword(_ password: String) {
        _password = password
    }

    func connectNetwork(){
        let web3: CustomWeb3 = CustomWeb3.shared
        web3.attachNetworkObserver(self)
        self._network = web3.network
        web3.setOption()
    }

    func networkChanged(network: CustomWeb3Network) {
        self._network = network
    }

    func addressChanged(address: CustomAddress) {
        self._address = address
    }

    private func _encryptData(stringData: String, password: String) -> Data {
        let data: Data = stringData.data(using: String.Encoding.utf8)!
        let key256 = Array<UInt8>(hex: password)
        let iv = _loadIv()
        let aes = try! AES(key: key256, blockMode: CBC(iv: iv))
        let encryptedUint8 = try! aes.encrypt([UInt8](data))
        let encryptedData = Data(bytes: encryptedUint8, count: encryptedUint8.count)

        return encryptedData
    }

    private func _decryptData(encryptedData: Data, password: String) -> String {
        let key256 = Array<UInt8>(hex: password)
        let iv = _loadIv()
        let aes = try! AES(key: key256, blockMode: CBC(iv: iv))
        let decryptedUInt8 = try! aes.decrypt([UInt8](encryptedData))
        let decryptedData = String(bytes: decryptedUInt8, encoding: .utf8)!

        return decryptedData
    }


    private func _saveMnemonic(password: String) {
        let mnemonicEncrypted = _encryptData(stringData: _mnemonic!, password: password)
        userDefaults.set(mnemonicEncrypted, forKey: "mnemonic")
    }

    private func _loadMnemonic(password: String) -> String {
        let mnemonicEncrypted = userDefaults.data(forKey: "mnemonic")!
        let mnemonic = _decryptData(encryptedData: mnemonicEncrypted, password: password)

        return mnemonic
    }

    private func _savePrivateKey(key: String, name: String, password: String) {
        let encryptPrivateKey = _encryptData(stringData: key, password: password)
        userDefaults.set(encryptPrivateKey, forKey: "private_key"+name)
    }

    private func _loadPrivateKey(name: String, password: String) -> String? {
        guard let encryptPrivateKey = userDefaults.data(forKey: "private_key"+name) else { return nil }
        let privateKey = _decryptData(encryptedData: encryptPrivateKey, password: password)

        return privateKey
    }

    private func _delPrivateKey(name: String){
        userDefaults.removeObject(forKey: "name")
    }

    private func _saveIv(iv: [UInt8]) {
        let ivString = String(bytes: iv, encoding: .utf8)!
        if (!KeychainService.savePassword(service: "moahWallet", account: "iv", data: ivString)) {
            KeychainService.updatePassword(service: "moahWallet", account: "iv", data: ivString)
        }
    }

    private func _loadIv() -> [UInt8] {
        let ivString = KeychainService.loadPassword(service: "moahWallet", account: "iv")
        if(ivString == nil){
            let iv = Array(util.randomString(length: 16).utf8)
            _saveIv(iv: iv)
            return iv
        }
        else{
            return Array(ivString!.utf8)
        }
    }

    private func _generateKeyStore(password: String) {
        _keyStore = try! BIP32Keystore(mnemonics: _mnemonic!, password: password)
        _keyStoreManager = KeystoreManager([_keyStore!])
    }

    private func _saveKeyStore() {
        let keyData = try! JSONEncoder().encode(_keyStore!.keystoreParams)
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: userDir + "/keystore", withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        fileManager.createFile(atPath: userDir + "/keystore/key.json", contents: keyData)
    }

    private func _loadKeyStore() {
        let fileHandle = FileHandle.init(forReadingAtPath: userDir + "/keystore/key.json")
        let jsonFile = fileHandle?.readDataToEndOfFile()
        _keyStore = BIP32Keystore(jsonFile!)
        _keyStoreManager = KeystoreManager([_keyStore!])

        _loadPlainKeyStore()
    }

    private func _loadPlainKeyStore(){
        let ethAddress: EthAddress = EthAddress.address
        let pkPredicate = NSPredicate(format: "isPrivateKey == true")

        let addressArray = ethAddress.fetchAddress(pkPredicate)

        var plainArray: [PlainKeystore] = [PlainKeystore]()
        for address in addressArray{
            let privateKey = _loadPrivateKey(name: address.value(forKey: "name") as! String, password: _password!)
            let plainKeyStore = PlainKeystore(privateKey: privateKey!)!
            plainArray.append(plainKeyStore)
        }
        _plainKeyStoreManager = KeystoreManager(plainArray)

    }

    private func _regenerateKeyStore(oldPassword: String, password: String){
        try! _keyStore!.regenerate(oldPassword: oldPassword, newPassword: password)
        _saveKeyStore()
    }

    private func _reencryptMnemonic(oldPassword: String, password: String){
        let mnemonic = _loadMnemonic(password: oldPassword)
        let mnemonicEncrypted = _encryptData(stringData: mnemonic, password: password)
        userDefaults.set(mnemonicEncrypted, forKey: "mnemonic")
    }

    private func _reencryptPrivateKey(oldPassword: String, password: String){
        let ethAddress: EthAddress = EthAddress.address
        let pkPredicate = NSPredicate(format: "isPrivateKey == true")
        let addressArray = ethAddress.fetchAddress(pkPredicate)

        for address in addressArray{
            let name = address.value(forKey: "name") as! String
            let privateKey = _loadPrivateKey(name: name, password: oldPassword)!
            _savePrivateKey(key: privateKey, name: name, password: password)
        }
    }

    private func _hashPassword(password: [UInt8], salt: [UInt8]) -> [UInt8] {
        let hash = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        return hash
    }

    private func _unlockAccount() {
        let keyHex = KeychainService.loadPassword(service: "moahWallet", account: "password")!
        let ethAddress: EthAddress = EthAddress.address

        self._password = keyHex
        self._address = ethAddress.address
        ethAddress.attachAddressObserver(self)

        _loadKeyStore()
        _loadIsVerified()
        connectNetwork()
    }

    private func _initAccount(){
        let ethAddress: EthAddress = EthAddress.address
        let address = CustomAddress(address: _getLastAddressFromPath().address, name: "주 계정", isPrivateKey: false, path: _getLastPath())
        ethAddress.addAddress(address)
    }

    private func _getLastPath() -> String{
        let path = _keyStore!.paths
        var pathKey = Array(path.keys)
        pathKey = pathKey.sorted(by: <)

        return pathKey.last!
    }

    func _getLastAddressFromPath() -> EthereumAddress{
        let path = _keyStore!.paths
        var pathKey = Array(path.keys)
        pathKey = pathKey.sorted(by: <)
        let lastAddress = path[pathKey.last!]

        return lastAddress!
    }

    private func _createAccount(name: String) throws {
        let path = _keyStore!.paths
        let pathKey = Array(path.keys)
        var intArray: [Int] = [Int]()
        var newPathChar: String = String(pathKey.count)
        var newPath: String!

        for path in pathKey{
            intArray.append(Int(path.components(separatedBy: "/").last!)!)
        }
        intArray = intArray.sorted(by: <)

        for index in 0...pathKey.count-1{
            if(index != intArray[index]){
                newPathChar = String(index)
                break
            }
        }

        newPath = _keyStore!.rootPrefix + "/" + newPathChar

        do{
            try _keyStore?.createNewCustomChildAccount(password: _password!, path: newPath)
            _saveKeyStore()

            let ethAddress: EthAddress = EthAddress.address
            let address = CustomAddress(address: _keyStore!.paths[newPath]!.address, name: name, isPrivateKey: false, path: newPath)
            ethAddress.addAddress(address)
        }
        catch{
            throw error
        }
    }

    private func _saveIsVerified(){
        userDefaults.set(_isVerified, forKey: "isVerified")
    }

    private func _loadIsVerified(){
        _isVerified = userDefaults.bool(forKey: "isVerified")
    }

    private func _delAddressFromPath(account: CustomAddress){
        var newPath: [String: EthereumAddress] = [String: EthereumAddress]()
        for path in _keyStore!.paths{
            if(path.key == account.path){
                continue
            }
            newPath[path.key] = path.value
        }
        _keyStore?.paths = newPath
        _saveKeyStore()
    }

    private func _lockKeyData() {
        let ethAddress: EthAddress = EthAddress.address
        ethAddress.detachAddressObserver(self)

        if(_keyStore != nil){
            _saveKeyStore()
            _saveIsVerified()
        }
        _password = nil
        _keyStore = nil
        _mnemonic = nil
        _address = nil
        _plainKeyStoreManager = nil
    }
}