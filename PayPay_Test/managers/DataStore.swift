//
//  DataStore.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation

protocol DataStoreProtocol {
    func getExchangeRates(completion:  @escaping (_ rates: ExchangeRates?, _ err: AppErrors?) -> ())
    func getCurrencyList(completion:  @escaping (_ list: [Currency], _ err: AppErrors?) -> ())

}

class DataStore {
    static let shared = DataStore()
    var networkManager: NetworkManagerProtocol
    private let dataLoader: DataLoaderProtocol
    
    var currencyList: [Currency]!
    
    
    private init(networkManager: NetworkManagerProtocol = NetworkManager.shared, dataLoader: DataLoaderProtocol = DataLoader.shared) {
        self.networkManager = networkManager
        self.dataLoader = dataLoader
    }
    var userDefault: UserDefaults {
        return UserDefaults.standard
    }
    
    var exchangeRatesKey: String {
        return "ExchangeRates"
    }
}



extension DataStore: DataStoreProtocol {
    func getCurrencyList(completion: @escaping ([Currency], AppErrors?) -> ()) {
        if self.currencyList != nil {
            completion(currencyList, nil)
            return
        }
        
        let bundle = Bundle(for: type(of: self))
        let list = dataLoader.loadModel(ModelJSONPath.currencyList.rawValue, as: [Currency].self, bundle: bundle)
        if let currencyList = list.0 {
            self.currencyList = currencyList
            completion(currencyList, nil)
            return
        }
        
        return completion([], list.1)
    }
    
    
    func getExchangeRates(completion: @escaping (ExchangeRates?, AppErrors?) -> ()) {
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
