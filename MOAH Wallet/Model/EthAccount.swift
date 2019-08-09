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
    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

    private var _keyStoreManager: KeystoreManager?
    private var _keyStore: BIP32Keystore?
    private var _plainKeystore: [PlainKeystore]?
    private var _mnemonic: Mnemonics?
    private var _password: String?
    private var _isVerified: Bool = false
    private var _timer: Timer?
    private var _address: Address?
    private var _addressArray: [CustomAddress] = [CustomAddress]()

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

    func lockAccount() {
        _lockKeyData()
    }

    func invalidateTimer() {
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
            _mnemonic = try! Mnemonics(_loadMnemonic(password: _password!))
        }
        let mnemonicIns = _mnemonic!.string.components(separatedBy: " ")

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
        guard let privateKey = _loadPrivateKey(name: getAddressName()!, password: _password!) else{
            let privateKey2 = try! _keyStore?.UNSAFE_getPrivateKeyData(password: _password!, account: _address!)

            return privateKey2!.toHexString()
        }
        return privateKey
    }

    func setAccount() -> Bool {
        _saveMnemonic(password: _password!)
        _generateKeyStore(password: _password!)
        _saveKeyStore()
        _generateAddressArray()
        setAddress(index: nil)

        return true
    }

    func getAccount(key: String, name: String) throws -> Bool{
        guard _checkAccount(name: name) else{ return false }

        do{
            let keyStore = try PlainKeystore(privateKey: key)
            if(!_checkAccount(account: keyStore.addresses.first!.description)){
                throw GetAccountError.existingAccount
            }

            let address = CustomAddress(address: keyStore.addresses.first!.description, name: name, isPrivateKey: true, path: nil)
            _savePrivateKey(key: key, name: address.name, password: _password!)
            _addAddress(address: address)
            setAddress(address: _addressArray.last!.address)
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
        guard _checkAccount(name: name) else{ return false }

        do {
            try _createAccount(name: name)
        } catch {
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
        if(account.address == _address!.description){
            setAddress(address: _addressArray.first!.address)
        }
        let index = _addressArray.firstIndex(where: {$0.name == account.name})
        _addressArray.remove(at: index!)
        _saveAddress()
    }

    func verifyAccount(){
        _isVerified = true
        _saveIsVerified()
    }

    func getIsVerified() -> Bool {
        return _isVerified
    }

    func setAddress(index: Int?) {
        if (index == nil || index! > 9) {
            _address = Address(_addressArray.first!.address)
        } else {
            _address = Address(_addressArray[index!].address)
        }
        _saveAddressSelected()
    }

    func setAddress(address: String) {
        _address = Address(address)
        _saveAddressSelected()
    }

    func getAddress() -> Address? {
        return _address
    }

    func getAddressArray() -> [CustomAddress]? {
        return _addressArray
    }

    func getAddressName() -> String? {
        for address in _addressArray{
            if(_address!.description == address.address){
                return address.name
            }
        }
        return nil
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
        let mnemonicEncrypted = _encryptData(stringData: _mnemonic!.string, password: password)
        userDefaults.set(mnemonicEncrypted, forKey: "mnemonic")
    }

    private func _loadMnemonic(password: String) -> String {
        let mnemonicEncrypted = userDefaults.data(forKey: "mnemonic")!
        let mnemonic = _decryptData(encryptedData: mnemonicEncrypted, password: password)

        return mnemonic
    }

    private func _savePrivateKey(key: String, name: String, password: String) {
        let encryptPrivateKey = _encryptData(stringData: key, password: password)
        userDefaults.set(encryptPrivateKey, forKey: name)
    }

    private func _loadPrivateKey(name: String, password: String) -> String? {
        guard let encryptPrivateKey = userDefaults.data(forKey: name) else { return nil }
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
        _keyStore = BIP32Keystore(jsonFile!)!
        _keyStoreManager = KeystoreManager([_keyStore!])

        _loadPlainKeyStore()
    }

    private func _loadPlainKeyStore(){
        for address in _addressArray{
            if(address.isPrivateKey == true){
                let privateKey = _loadPrivateKey(name: address.name, password: _password!)
                let plainKeyStore = try! PlainKeystore(privateKey: privateKey!)
                _keyStoreManager!.append(plainKeyStore)
            }
        }
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
        for address in _addressArray{
            if(address.isPrivateKey){
                let privateKey = _loadPrivateKey(name: address.name, password: oldPassword)!
                _savePrivateKey(key: privateKey, name: address.name, password: password)
            }
        }
    }

    func _setPassword(_ password: String) {
        _password = password
    }

    private func _hashPassword(password: [UInt8], salt: [UInt8]) -> [UInt8] {
        let hash = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha256).calculate()
        return hash
    }

    private func _unlockAccount() {
        let keyHex = KeychainService.loadPassword(service: "moahWallet", account: "password")!
        self._password = keyHex
        _loadAddress()
        _loadAddressSelected()
        _loadKeyStore()
        _loadIsVerified()
    }

    private func _saveAddressSelected() {
        let addressSelected = _address?.description
        userDefaults.set(addressSelected, forKey: "addressSelected")
    }

    private func _loadAddressSelected(){
        let addressSelected = userDefaults.string(forKey: "addressSelected")
        if (addressSelected == nil) {
            setAddress(index: nil)
        } else {
            setAddress(address: addressSelected!)
        }
    }

    private func _saveAddress() {
        userDefaults.set(try! PropertyListEncoder().encode(_addressArray), forKey:"address")
    }

    private func _loadAddress(){
        if let rawArray = UserDefaults.standard.value(forKey:"address") as? Data {
            let addressArray = try! PropertyListDecoder().decode([CustomAddress].self, from: rawArray)
            _addressArray = addressArray
        }
        else{
            return
        }
    }

    private func _addAddress(address: CustomAddress){
        _addressArray.append(address)
        _saveAddress()
    }

    private func _generateAddressArray(){
        let address = CustomAddress(address: _getLastAddress().description, name: "주 계정", isPrivateKey: false, path: _getLastPath())
        _addressArray = [address]
        _saveAddress()
    }

    private func _getLastAddress() -> Address{
        let path = _keyStore!.paths
        var pathKey = Array(path.keys)
        pathKey = pathKey.sorted(by: <)
        let lastAddress = path[pathKey.last!]

        return lastAddress!
    }

    private func _getLastPath() -> String{
        let path = _keyStore!.paths
        var pathKey = Array(path.keys)
        pathKey = pathKey.sorted(by: <)

        return pathKey.last!
    }

    private func _createAccount(name: String) throws {
        let path = _keyStore!.paths
        var pathKey = Array(path.keys)
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

            let address = CustomAddress(address: _keyStore!.paths[newPath]!.description, name: name, isPrivateKey: false, path: newPath)
            _addAddress(address: address)
            setAddress(address: _addressArray.last!.address)
        }
        catch{
            throw error
        }
    }

    private func _delAddressFromPath(account: CustomAddress){
        var newPath: [String: Address] = [String: Address]()
        for path in _keyStore!.paths{
            if(path.key == account.path){
                continue
            }
            newPath[path.key] = path.value
        }
        _keyStore?.paths = newPath
        _saveKeyStore()
    }

    private func _checkAccount(name: String) -> Bool{
        var count = 0
        for address in _addressArray{
            if(address.isPrivateKey == false){count += 1}
            if(address.name == name){
                return false
            }
        }
        if(count > 9) { return false }
        else{ return true }
    }

    private func _checkAccount(account: String) -> Bool{
        for address in _addressArray{
            if(address.address == account){ return false}
        }
        return true
    }

    private func _saveIsVerified(){
        userDefaults.set(_isVerified, forKey: "isVerified")
    }

    private func _loadIsVerified(){
        _isVerified = userDefaults.bool(forKey: "isVerified")
    }

    private func _lockKeyData() {
        if(_keyStore != nil){
            _saveKeyStore()
            _saveAddressSelected()
            _saveIsVerified()
        }
        _password = nil
        _keyStore = nil
        _mnemonic = nil
        _address = nil
        _addressArray = [CustomAddress]()
    }
}