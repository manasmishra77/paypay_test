//
//  MovieListVCViewModel.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

protocol CurrencyListVCViewModelDelegate: AnyObject {
    func currencyList(list: [Currency], with err: AppErrors?)
    func exchangeRates(rates: ExchangeRates?, with err: AppErrors?)
}



class CurrencyListVCViewModel {
    
    var dataStore: DataStoreProtocol!
    var delegate: CurrencyListVCViewModelDelegate!
    
    var selectedCurrencyID: String?
    var enteredCurrency: String?
    
    
    
    init(dataStore: DataStoreProtocol = DataStore.shared, delegate: CurrencyListVCViewModelDelegate) {
        self.dataStore = dataStore
        self.delegate = delegate
    }
    
    func getCurrencyList() {
        dataStore.getCurrencyList {[weak self] (list, err) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.delegate.currencyList(list: list, with: err)
            }
        }
    }
    
    func getExchangeRates() {
        dataStore.getExchangeRates {[weak self] (rates, err) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.delegate.exchangeRates(rates: rates, with: err)
            }
        }
    }
    
    var exchangeRateListDict: [String: Double] {
        var rateDict: [String: Double] = [:]
        
        return rateDict
    }

    
    
    
    
}

