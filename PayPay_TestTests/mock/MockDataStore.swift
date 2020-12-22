//
//  MockDataStore.swift
//  PayPay_TestTests
//
//  Created by Manas1 Mishra on 22/12/20.
//

import Foundation

@testable import PayPay_Test

class MockDataStore: DataStoreProtocol {

    func getExchangeRates(completion: @escaping (ExchangeRates?, AppErrors?) -> ()) {
        let bundle = Bundle(for: type(of: self))
        let result = DataLoader.shared.loadModel(ModelJSONPath.allExchangeRate.rawValue, as: ExchangeRates.self, bundle: bundle)
        completion(result.0, result.1)
    }
    
    func getCurrencyList(completion: @escaping ([Currency], AppErrors?) -> ()) {
        DataStore.shared.getCurrencyList(completion: completion)
    }
        
}
