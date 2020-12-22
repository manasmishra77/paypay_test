//
//  CurrencyListViewModel.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import UIKit

class CurrencyListViewModel {
    
    var viewType: CurrencyList.ViewType
    
    // used for currency list
    var currencyList: [Currency] = []
    
    // used for exchange rate list
    var exchangeRates: [(String, Double)] = []
    var selectedCurrency: String = ""
    
    var listCount: Int {
        if viewType == .exchangeRates {
            return exchangeRates.count
        }
        return currencyList.count
    }
    
    init(_ type: CurrencyList.ViewType, exchangeRates: [(String, Double)], currencyList: [Currency]) {
        self.viewType = type
        self.currencyList = currencyList
        self.exchangeRates = exchangeRates
    }
    
    var titleLabelText: String {
        if viewType == .currencyList {
            return "Select Currency"
        }
        return "Exchange rates for \(selectedCurrency)"
    }
    
}
