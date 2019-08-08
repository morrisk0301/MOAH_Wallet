//
//  AppDelegate.swift
//  MOAH Wallet
//
//  Created by 김경인 on 2019-06-29.
//  Copyright © 2019 Sejong University Alom. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundTime: Date?
    var foregroundTime: Date?
    var isInit = true

    let account: EthAccount = EthAccount.accountInstance
    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 2.0)
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let key = userDefaults.string(forKey: "salt")
        let lock = userDefaults.bool(forKey: "useLock")

        if(key != nil){
            if(lock){
                let lockVC = LockVC()
                self.window?.rootViewController = lockVC
                self.window?.makeKeyAndVisible()
            }else{
                self.account.bioProceed()
                let mainContainerVC = MainContainerVC()
                self.window?.rootViewController = mainContainerVC
                self.window?.makeKeyAndVisible()
            }
        }
        else{
            let mainView = MainViewController(nibName: nil, bundle: nil)
            self.window!.rootViewController = mainView
            self.window?.makeKeyAndVisible()
        }
        // Override point for customization after application launch.
        isInit = false
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        backgroundTime = Date()
        foregroundTime = nil
        let key = userDefaults.string(forKey: "salt")
        if(key != nil && account.getKeyStoreManager() != nil){
            account.lockAccount()
        }
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        foregroundTime = Date()

        let key = userDefaults.string(forKey: "salt")
        let lock = userDefaults.bool(forKey: "useLock")
        let compareDate = foregroundTime!.timeIntervalSinceReferenceDate - backgroundTime!.timeIntervalSinceReferenceDate
        if(!isInit){
            if(key != nil){
                if(compareDate > 180){
                    if(lock){
                        let lockVC = LockVC()
                        self.window?.rootViewController = lockVC
                        self.window?.makeKeyAndVisible()
                    }
                    else{
                        self.account.bioProceed()
                        let mainContainerVC = MainContainerVC()
                        self.window?.rootViewController = mainContainerVC
                        self.window?.makeKeyAndVisible()
                    }
                }
                else{
                    self.account.bioProceed()
                }
            }
            else{
                let mainView = MainViewController(nibName: nil, bundle: nil)
                self.window!.rootViewController = mainView
                self.window?.makeKeyAndVisible()
            }
        }
        backgroundTime = nil
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
