//
// Created by 김경인 on 2019-08-19.
// Copyright (c) 2019 Sejong University Alom. All rights reserved.
//

import UIKit
import Reachability
import UIKit

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }

    var reachabilityStatus: Reachability.Connection = .none
    let reachability = Reachability()!

    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                selector: #selector(self.reachabilityChanged(_:)),
                name: Notification.Name.reachabilityChanged,
                object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }

    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                name: Notification.Name.reachabilityChanged,
                object: reachability)
    }

    func alertUser(){
        let alertController = UIAlertController(title: "Error".localized, message: "Network is unreachable.\nPlease check your network.".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Retry".localized, style: .default){(_) in
            if (self.reachability.connection == .none){
                self.alertUser()
            }
        }
        alertController.addAction(ok)
        UIApplication.topViewController()?.present(alertController, animated: false)
    }

    @objc func reachabilityChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            alertUser()
        case .wifi:
            debugPrint("Network reachable through WiFi")
        case .cellular:
            debugPrint("Network reachable through cellular")
        }
    }
}