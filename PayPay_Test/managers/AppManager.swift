//
//  AppManager.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//


import UIKit

class AppManager: NSObject {
    static let shared = AppManager()
    var networkManager: NetworkManager {
        return NetworkManager.shared
    }
    
}



