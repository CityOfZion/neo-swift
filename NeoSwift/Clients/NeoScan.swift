//
//  NeoScan.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

@objc public class NeoScan: NSObject {
    
    var baseEndpoint = "https://neoscan.io/api/main_net"
    
    public var network: Network = .main
    
    init(network: Network) {
        self.network = network
    }
    
    enum APIEndpoints: String {
        case getHistory = "/v1/get_address_abstracts/" //with address
    }
    
    @objc func sendFullNodeRequest(_ endpointResource: String, params: [Any]?, completion :@escaping (JSONDictionary?, NeoClientError?) -> Void) {
        
        if network == .test {
            baseEndpoint = "https://neoscan-testnet.io/api/test_net"
        } else if network == .privateNet {
            baseEndpoint = "https://privatenet.o3.network/api/main_net"
        }
        
        let fullURL = baseEndpoint + endpointResource
        let request = NSMutableURLRequest(url: URL(string: fullURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(nil, NeoClientError(.invalidRequest))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? JSONDictionary else {
                completion(nil, NeoClientError(.invalidData))
                return
            }
            
            if json == nil {
                completion(nil, NeoClientError(.invalidData))
                return
            }
            
            completion(json, nil)
        }
        task.resume()
    }
    
    @objc public func getTransactionHistory(address: String, page: Int, completion: @escaping(NEOScanTransactionHistory?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getHistory.rawValue + address + "/" + String(page)
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(NEOScanTransactionHistory.self, from: data) else {
                        completion(nil, NeoClientError(.invalidData))
                        return
                }
                completion(jsonResult, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
}
