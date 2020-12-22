//
//  CurrencyListViewModel.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 19/12/20.
//

import UIKit

class CurrencyListViewModel {
    
    var viewType: CurrencyList.ViewType
    
    var currencyList: [Currency] = []
    var exchangeRates: [String: Double] = [:]
    
    var listCount: Int {
        if viewType == .exchangeRates {
            return exchangeRates.count
        }
        return currencyList.count
    }
    
    init(_ type: CurrencyList.ViewType, exchangeRates: [String: Double], currencyList: [Currency]) {
        self.viewType = type
        self.currencyList = currencyList
        self.exchangeRates = exchangeRates
    }
    
}
