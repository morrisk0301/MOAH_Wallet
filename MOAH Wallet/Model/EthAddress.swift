//
// Created by 김경인 on 2019-08-18.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import Foundation
import web3swift
import CoreData

class EthAddress {

    static let address = EthAddress()

    private let userDefaults = UserDefaults.standard

    private var _address: CustomAddress?
    private var observers: [AddressObserver] = [AddressObserver]()

    var address: CustomAddress? {
        set(value){
            _address = value
            _saveAddressSelected()
            notify()
        }
        get{
            return _address
        }
    }

    private var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        return appDelegate.persistentContainer.viewContext
    }

    private init(){
        _loadAddressSelected()
    }

    func setAddress(index: Int?) {
        var addressIndex = index

        if (addressIndex == nil || addressIndex! > 9) {
            addressIndex = 0
        }

        let addressArray = self.fetchAddress(nil)
        let address = addressArray[addressIndex!].value(forKey: "address") as! String
        let name = addressArray[addressIndex!].value(forKey: "name") as! String
        let isPrivateKey = addressArray[addressIndex!].value(forKey: "isPrivateKey") as! Bool
        let path = addressArray[addressIndex!].value(forKey: "path") as! String
        let addressSelect = CustomAddress(address: address, name: name, isPrivateKey: isPrivateKey, path: path)
        self.address = addressSelect
    }

    func addAddress(_ address: CustomAddress) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "MOAHAddress", in: managedContext) else { return }

        let newAddress = NSManagedObject(entity: entity, insertInto: managedContext)

        newAddress.setValue(address.address, forKey: "address")
        newAddress.setValue(address.name, forKey: "name")
        newAddress.setValue(address.isPrivateKey, forKey: "isPrivateKey")
        newAddress.setValue(address.path, forKey: "path")

        do {
            try managedContext.save()
            self.address = address
        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func fetchAddress(_ predicate: NSPredicate?) -> [MOAHAddress] {
        guard let managedContext = managedContext else {
            return []
        }

        let fetchRequest = NSFetchRequest<MOAHAddress>(entityName: "MOAHAddress")
        fetchRequest.predicate = predicate

        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("error : \(error)")
        }

        return []
    }

    func deleteAddress(name: String){
        guard let managedContext = managedContext else { return }

        let fetchRequest = NSFetchRequest<MOAHAddress>(entityName: "MOAHAddress")
        let namePredicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = namePredicate

        do {
            let result = try managedContext.fetch(fetchRequest)

            let objectDelete = result[0]
            managedContext.delete(objectDelete)

            try managedContext.save()

        } catch let error as NSError {
            print("error: \(error)")
        }
    }

    func checkPrivate(_ address: String) -> Bool {
        let addressPredicate = NSPredicate(format: "address = %@", address)
        let pkPredicate = NSPredicate(format: "isPrivateKey == true")
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [addressPredicate, pkPredicate])
        let addressArray = self.fetchAddress(andPredicate)

        return addressArray.count != 0
    }

    func checkAddressCount() -> Bool {
        let pkPredicate = NSPredicate(format: "isPrivateKey == false")
        let addressArray = self.fetchAddress(pkPredicate)
        return addressArray.count > 9
    }

    func checkAddressName(_ name: String) -> Bool {
        let namePredicate = NSPredicate(format: "name = %@", name)
        let addressArray = self.fetchAddress(namePredicate)

        return addressArray.count != 0
    }

    func checkAddressExists(_ address: String) -> Bool {
        let addressPredicate = NSPredicate(format: "address = %@", address)
        let addressArray = self.fetchAddress(addressPredicate)

        return addressArray.count != 0
    }

    func delIfGetAccountExists(_ address: String) {
        let addressPredicate = NSPredicate(format: "address = %@", address)
        let addressArray = self.fetchAddress(addressPredicate)
        if(addressArray.count > 0){
            let name = addressArray.first!.value(forKey: "name") as! String
            self.deleteAddress(name: name)
            userDefaults.removeObject(forKey: "private_key"+name)
        }
    }

    func attachAddressObserver(_ observer: AddressObserver){
        observers.append(observer)
    }

    func detachAddressObserver(_ delObserver: AddressObserver){
        guard let index = self.observers.firstIndex(where: { $0.id == delObserver.id }) else {
            return
        }
        self.observers.remove(at: index)
    }

    private func notify(){
        for observer in observers {
            observer.addressChanged(address: self.address!)
        }
    }

    private func _saveAddressSelected() {
        userDefaults.set(try! PropertyListEncoder().encode(address), forKey:"address")
    }

    private func _loadAddressSelected(){
        if let rawArray = UserDefaults.standard.value(forKey:"address") as? Data {
            let address = try! PropertyListDecoder().decode(CustomAddress.self, from: rawArray)
            self.address = address
        }
        else{
            return
        }
    }

}
