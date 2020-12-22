//
//  Models.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation

struct Currency: Codable {
    let countryCode : String?
    let countryName : String?
    
    enum CodingKeys: String, CodingKey {

        case countryName = "name"
        case countryCode = "code"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        countryCode = try? values.decodeIfPresent(String.self, forKey: .countryCode)
        countryName = try? values.decodeIfPresent(String.self, forKey: .countryName)
    }
}


struct ExchangeRates: Codable {
    let success : Bool?
    let timestamp : Int?
    let quotes : [String: Double]?
    
    var date: Date? {
        guard let timeStamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        return date
    }

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case timestamp = "timestamp"
        case quotes = "quotes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try? values.decodeIfPresent(Bool.self, forKey: .success)
        timestamp = try? values.decodeIfPresent(Int.self, forKey: .timestamp)
        quotes = try? values.decodeIfPresent([String: Double].self, forKey: .quotes)
    }
}
