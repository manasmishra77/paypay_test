//
//  MovieListVCViewModel.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

protocol CurrencyListVCViewModelDelegate: AnyObject {
    func currencyListFetched(list: [Currency], with err: AppErrors?)
    func exchangeRatesFetched(rates: [(String, Double)], currency: String, with err: AppErrors?)
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
                self.delegate.currencyListFetched(list: list, with: err)
            }
        }
    }
    
    func getExchangeRates() {
        dataStore.getExchangeRates {[weak self] (rates, err) in
            guard let self = self else {return}
            guard let rateDict = rates?.quotes else {
                DispatchQueue.main.async {
                    self.delegate.exchangeRatesFetched(rates: [], currency: self.selectedCurrencyID ?? "", with: AppErrors.noData(nil))
                }
                return
            }
            let multiplier = rateDict["USD\(self.selectedCurrencyID ?? "")"]
            var rateArr: [(String, Double)] = []
            
            for (key, val) in rateDict {
                let currencyName = String(key.dropFirst(3))
                let currencyVal = val/(multiplier ?? 1)
                rateArr.append((currencyName, currencyVal))
            }
            DispatchQueue.main.async {
                self.delegate.exchangeRatesFetched(rates: rateArr, currency: self.selectedCurrencyID ?? "", with: nil)
            }
        }
    }
    
}

