//
//  NetworkManager.swift
//  PayPay_Test
//
//  Created by Manas1 Mishra on 21/12/20.
//


import UIKit

protocol NetworkManagerProtocol {
    func doNetworkCallForLiveRatesList(completion: @escaping NetworkManager.Completion)
}


class NetworkManager: NSObject, NetworkManagerProtocol {
    static let shared = NetworkManager()
        
    var apiKey: String {
        return "21138ad7f72e77450bf7511c5410d593"
    }
    
    typealias Completion = (_ code: Int, _ model: Any?, _ error: AppErrors?) -> ()
        
    enum EndPoint: String {
         
        case getLiveRates = "/live?access_key=21138ad7f72e77450bf7511c5410d593"
        
        var baseDomain: String {
            return "http://api.currencylayer.com"
        }
        
        var url: URL? {
            return URL(string: baseDomain + self.rawValue)
        }
    }
        
    
    func doNetworkCallForLiveRatesList(completion: @escaping Completion) {
        
       
        guard let url = EndPoint.getLiveRates.url else {
            let err = AppErrors.urlMakingFailed(nil)
            completion(err.code, nil, err)
            return
        }
        
        doNetworkCall(url: url) { (code, data, error) in
            if let error = error {
                // error from response
                completion(error.code, nil, error)
                return
            }
            let resModel = self.parseData(data as? Data, modelType: ExchangeRates.self)
            if let error = resModel.e {
                // error in parsing
                completion(error.code, nil, error)
                return
            }
            if let model = resModel.m {
                // success
                completion(code, model, nil)
            } else {
                completion(code, nil, nil)
            }
        }
    }
    
    
    func doNetworkCall(url: URL, completion: @escaping Completion) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 10
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            if let res = response as? HTTPURLResponse {
                if let err = error {
                    let err = AppErrors.apiResponse(res.statusCode, err)
                    completion(err.code, nil, err)
                    return
                }
                completion(res.statusCode, data, nil)
            } else {
                let err = AppErrors.apiResponse(500, nil)
                completion(err.code, nil, err)
            }
        })

        task.resume()
    }
    
    func parseData<T: Codable>(_ data: Data?, modelType: T.Type) -> (m: T?, e: AppErrors?) {
        guard let data = data else {
            return (nil, AppErrors.noData(nil))
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return (model, nil)
        } catch {
            return (nil, AppErrors.parsingFailed(error))
        }
    }
    
    
}


