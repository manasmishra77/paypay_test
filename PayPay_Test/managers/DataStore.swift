//
//  DataStore.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation

protocol DataStoreProtocol {
    func getExchangeRates(completion:  @escaping (_ rates: ExchangeRates?, _ err: Error?) -> ())
}

class DataStore {
    static let shared = DataStore()
    let networkManager: NetworkManagerProtocol
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    var userDefault: UserDefaults {
        return UserDefaults.standard
    }
    
    var exchangeRatesKey: String {
        return "ExchangeRates"
    }
}
extension DataStore: DataStoreProtocol {
    func getExchangeRates(completion: @escaping (ExchangeRates?, Error?) -> ()) {
        // check whether rates present in userdefault
        // if yes, than check the time stamp is not older than 30mins
        // else, fetch from server and save
        
        if let rateData = userDefault.object(forKey: exchangeRatesKey) as? Data {
            if let exchangeRates = try? PropertyListDecoder().decode(ExchangeRates.self, from: rateData) {
                if let exchangeRateDate = exchangeRates.date {
                    let timeDiffernce = Date().timeIntervalSince(exchangeRateDate)
                    if timeDiffernce <= 1800 {
                        completion(exchangeRates, nil)
                        return
                    }
                }
            }
            userDefault.removeObject(forKey: exchangeRatesKey)
        }
        
        // fetch from api
        
        networkManager.doNetworkCallForLiveRatesList { (code, rates, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            if let rates = rates as? ExchangeRates {
                DispatchQueue.global(qos: .default).async {
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(rates), forKey: self.exchangeRatesKey)
                }
                completion(rates, nil)
            }
        }
    }
    
}
