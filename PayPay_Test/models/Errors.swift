//
//  Errors.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//

import Foundation

enum AppErrors: Error {
    case jsonFileLoading(Error?)
    case unableToFindJsonFile(Error?)
    case urlMakingFailed(Error?)
    case apiResponse(Int, Error?)
    case parsingFailed(Error?)
    case noData(Error?)
    
    var code: Int {
        switch self {
        case .jsonFileLoading( _):
            return 411
        case .unableToFindJsonFile( _):
            return 412
        case .urlMakingFailed(_):
            return 413
        case .apiResponse(let code, _):
            return code
        case .parsingFailed(_):
            return 414
        case .noData(_):
            return 415
        }
    }
    var msg: String {
        switch self {
        case .jsonFileLoading(let err):
            return "Unable to load json file \(String(describing: err)))"
        case .unableToFindJsonFile(let err):
            return "Unable to find json file \(String(describing: err))"
        case .urlMakingFailed(let err):
            return "Unable to make url \(String(describing: err))"
        case .apiResponse(_, let err):
            return "Api failure \(String(describing: err))"
        case .parsingFailed(let err):
            return "Parsing failed \(String(describing: err))"
        case .noData(let err):
            return "No response data \(String(describing: err))"
        }
    }
}


