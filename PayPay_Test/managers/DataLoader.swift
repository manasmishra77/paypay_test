//
//  DataLoader.swift
//  PayU_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation

enum ModelJSONPath: String {
    case currencyList = "CurrencyList"
}

func loadModel<T: Decodable>(_ fileName: String, as type: T.Type = T.self, bundle: Bundle) -> (T?, AppErrors?) {
    let data: Data
    
    guard let file = bundle.url(forResource: fileName, withExtension: "json") else {
        return (nil, AppErrors.unableToFindJsonFile(nil))
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch  {
        return (nil, AppErrors.jsonFileLoading(error))
    }
    
    do {
        let decoder = JSONDecoder()
        let model = try decoder.decode(T.self, from: data)
        return (model, nil)
    } catch  {
        return (nil, AppErrors.jsonFileLoading(error))
    }
}
