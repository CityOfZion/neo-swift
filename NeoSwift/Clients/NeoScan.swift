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
    
    var baseEndpoint = "https://api.neoscan.io/api/main_net"
    
    public var network: Network = .main
    
    init(network: Network) {
        self.network = network
    }
    
    enum APIEndpoints: String {
        case getHistory = "/v1/get_address_abstracts/"
        case getHistoryTwoAddresses = "/v1/get_address_to_address_abstracts/"
        case getAllNodes = "/v1/get_all_nodes"
        case getBalance = "/v1/get_balance/"
        case getClaimable = "/v1/get_claimable/"
        case getClaimed = "/v1/get_claimed/"
        case getBlock = "/v1/get_block/"
        case getLatestBlock = "/v1/get_height"
        case getLastTransactions = "/v1/get_last_transactions_by_address/"
        case getTransaction = "/v1/get_transaction/"
        case getUnclaimed = "/v1/get_unclaimed/"
    }
    
    @objc func sendFullNodeRequest(_ endpointResource: String, params: [Any]?, completion :@escaping (Any?, NeoClientError?) -> Void) {
        if network == .test {
            baseEndpoint = "https://api.neoscan.io/api/test_net"
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
                guard let jsonArray = try? JSONSerialization.jsonObject(with: data!, options: []) as? [Any] else {
                    completion(nil, NeoClientError(.invalidData))
                    return
                }
                if jsonArray != nil {
                    completion(jsonArray, nil)
                    return
                }
                completion(nil, NeoClientError(.invalidData))
                return
            }
            
            completion(json, nil)
        }
        task.resume()
    }
    
    @objc public func getTransactionHistory(address: String, page: Int, completion: @escaping(TransactionHistory?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getHistory.rawValue + address + "/" + String(page)
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            self.doDeserializeToTransactionHistory(jsonResult: result as? JSONDictionary, error: error, completion: completion)
        }
    }
    
    @objc public func getTransactionHistory(address1: String, address2: String, page: Int, completion: @escaping(TransactionHistory?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getHistoryTwoAddresses.rawValue + address1 + "/" + address2 + "/" + String(page)
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            self.doDeserializeToTransactionHistory(jsonResult: result as? JSONDictionary, error: error, completion: completion)
        }
    }
    
    @objc public func getAllNodes(completion: @escaping([NEONode]?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getAllNodes.rawValue
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result as? [JSONDictionary] {
                let decoder = JSONDecoder()
                var nodes = [NEONode]()
                for json in response {
                    guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                        let node = try? decoder.decode(NEONode.self, from: data) else {
                            completion(nil, NeoClientError(.invalidData))
                            return
                    }
                    nodes.append(node)
                }
                completion(nodes, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    @objc public func getBalance(address: String, completion: @escaping(BalanceResponse?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getBalance.rawValue + address
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(BalanceResponse.self, from: data) else {
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
    
    @objc public func getClaimable(address: String, completion: @escaping(Unclaimed?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getClaimable.rawValue + address
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(Unclaimed.self, from: data) else {
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
    
    @objc public func getClaimed(address: String, completion: @escaping(ClaimedResponse?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getClaimed.rawValue + address
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(ClaimedResponse.self, from: data) else {
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
    
    @objc public func getBlock(blockHash: String, completion: @escaping(Block?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getBlock.rawValue + blockHash
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(Block.self, from: data) else {
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
    
    @objc public func getLatestBlock(completion: @escaping(BlockHeight?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getLatestBlock.rawValue
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(BlockHeight.self, from: data) else {
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
    
    @objc public func getLastTransactions(address: String, page: Int, completion: @escaping([TransactionModel]?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getLastTransactions.rawValue + address + "/" + String(page)
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode([TransactionModel].self, from: data) else {
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
    
    @objc public func getTransaction(txHash: String, completion: @escaping(TransactionModel?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getTransaction.rawValue + txHash
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(TransactionModel.self, from: data) else {
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
    
    @objc public func getUnclaimed(address: String, completion: @escaping(Unclaimed?, NeoClientError?) -> Void) {
        let endpoint = APIEndpoints.getUnclaimed.rawValue + address
        sendFullNodeRequest(endpoint, params: nil) { result, error in
            if let response = result {
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let jsonResult = try? decoder.decode(Unclaimed.self, from: data) else {
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
    
    private func doDeserializeToTransactionHistory(jsonResult: JSONDictionary?, error: NeoClientError?, completion: @escaping(TransactionHistory?, NeoClientError?) -> Void) {
        if let response = jsonResult {
            let decoder = JSONDecoder()
            guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                let jsonResult = try? decoder.decode(TransactionHistory.self, from: data) else {
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
