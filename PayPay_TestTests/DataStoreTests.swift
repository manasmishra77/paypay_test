//
//  DataStoreTests.swift
//  PayPay_TestTests
//
//  Created by Manas1 Mishra on 22/12/20.
//

import XCTest
@testable import PayPay_Test

class DataStoreTests: XCTestCase {
    
    var dataStore: DataStore!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataStore = DataStore.shared
        dataStore.networkManager = MockNetworkManager()
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
    
    func testGetCurrencyListForFirstTime() {
        dataStore.currencyList = nil
        let exp = expectation(description: "Expect")

        dataStore.getCurrencyList { (_, _) in
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // assert
            XCTAssert(self.dataStore.currencyList.count == 169, "all currency not fetched")

            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testGetCurrencyList() {
        let exp = expectation(description: "Expect")
        dataStore.currencyList = []

        dataStore.getCurrencyList { (_, _) in
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // assert
            XCTAssert(self.dataStore.currencyList.count == 0, "currency not fetched from memory")

            exp.fulfill()
        }
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    

}
