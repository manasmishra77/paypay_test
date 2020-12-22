//
//  CurrencyListViewModelTests.swift
//  PayPay_TestTests
//
//  Created by Manas1 Mishra on 22/12/20.
//

import XCTest
@testable import PayPay_Test

class CurrencyListViewModelTests: XCTestCase {
    
    var dataStore: MockDataStore!
    var viewModel: CurrencyListVCViewModel!
    
    // testing variable
    var delegateCurrencyList: [Currency] = []
    var delegateExchangeRates: [(String, Double)]!
    var delegateError: AppErrors?
    


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataStore = MockDataStore()
        viewModel = CurrencyListVCViewModel(dataStore: dataStore, delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetCurrencyList() {
        // set up
        self.delegateError = nil
        delegateCurrencyList = []
        let exp = expectation(description: "Expect")
        
        
        //execute
        self.viewModel.getCurrencyList()



        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // assert
            XCTAssert(self.delegateCurrencyList.count == 169, "all currency fetched")

            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testGetExchangeRatesWhenExhangeRates0() {
        // set up
        self.delegateError = nil
        delegateCurrencyList = []
        delegateExchangeRates = []
        self.viewModel.enteredCurrency = "0"
        self.viewModel.selectedCurrencyID = "ZMK"
        let exp = expectation(description: "Expect")
        
        //execute
        self.viewModel.getExchangeRates()



        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // assert
            XCTAssert(self.delegateExchangeRates.count == 168, "all exchange rates fetched")
            XCTAssert(self.delegateExchangeRates[0].1 == 0, "value > 0")
            XCTAssert(self.delegateExchangeRates[167].1 == 0, "value > 0")

            XCTAssert(self.delegateExchangeRates[1].1 == 0, "value > 0")

            XCTAssert(self.delegateExchangeRates[166].1 == 0, "value > 0")

            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testGetExchangeRatesWhenExhangeRates1() {
        // set up
        self.delegateError = nil
        delegateCurrencyList = []
        delegateExchangeRates = []
        self.viewModel.enteredCurrency = "1"
        self.viewModel.selectedCurrencyID = "ZMW"
        let exp = expectation(description: "Expect")
        dataStore.getExchangeRates { (rates, err) in
            XCTAssert(err == nil, "rates can't be fetched")
            
            //execute
            self.viewModel.getExchangeRates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // assert
                let multiplier = rates?.quotes?["USDZMW"] ?? 1
                
                for eachRates in self.delegateExchangeRates {
                    let expected = (eachRates.1 *  multiplier).rounded(toPlaces: 3)
                    let actual = (rates?.quotes?["USD\(eachRates.0)"])?.rounded(toPlaces: 3) ?? 0
                    XCTAssert((actual < expected + 1) && (actual > expected - 1), "not correct value")
                }

                exp.fulfill()
            }
            
            
            
        }
        
        
        



      
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    

}

extension CurrencyListViewModelTests: CurrencyListVCViewModelDelegate {
    func currencyListFetched(list: [Currency], with err: AppErrors?) {
        self.delegateCurrencyList = list
        self.delegateError = err
    }
    
    func exchangeRatesFetched(rates: [(String, Double)], currency: String, with err: AppErrors?) {
        self.delegateExchangeRates = rates
        self.delegateError = err
    }
    
    
}
