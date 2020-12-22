//
//  MockNetworkManager.swift
//  PayPay_TestTests
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation
@testable import PayPay_Test

class MockNetworkManager: NetworkManagerProtocol {
    var datamodelPath: ModelJSONPath = .allExchangeRate
    func doNetworkCallForLiveRatesList(completion: @escaping NetworkManager.Completion) {
        let bundle = Bundle(for: type(of: self))
        let model = DataLoader.shared.loadModel(datamodelPath.rawValue, as: ExchangeRates.self, bundle: bundle)
        completion(200, model, nil)
    }
    
}
