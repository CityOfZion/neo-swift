//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String : Any]

public enum NeoClientError: Error {
    case invalidSeed, invalidBodyRequest, invalidData, invalidRequest, noInternet
    
    var localizedDescription: String {
        switch self {
        case .invalidSeed:
            return "Invalid seed"
        case .invalidBodyRequest:
            return "Invalid body Request"
        case .invalidData:
            return "Invalid response data"
        case .invalidRequest:
            return "Invalid server request"
        case .noInternet:
            return "No Internet connection"
        }
    }
}

public enum NeoClientResult<T> {
    case success(T)
    case failure(NeoClientError)
}

public class NeoClient {
    public var seed = "http://seed4.neo.org:20332"
    public var fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v1/"
    public static let shared = NeoClient()
    private init() {}
    
    enum RPCMethod: String {
        case getBestBlockHash = "getbestblockhash"
        case getBlock = "getblock"
        case getBlockCount = "getblockcount"
        case getBlockHash = "getblockhash"
        case getConnectionCount = "getconnectioncount"
        case getTransaction = "getrawtransaction"
        case getTransactionOutput = "gettxout"
        case getUnconfirmedTransactions = "getrawmempool"
        case sendTransaction = "sendrawtransaction"
        //The following routes can't be invoked by calling an RPC server
        //We must use the wrapper for the nodes made by COZ
        case getBalance = "getbalance"
    }
    
    enum apiURL: String {
        case getBalance = "http://testnet-api.wallet.cityofzion.io/v1/address/balance/"
    }
    
    public init(seed: String) {
        self.seed = seed
    }
    
    func sendRequest(_ method: RPCMethod, params: [Any]?, completion: @escaping (NeoClientResult<JSONDictionary>) -> ()) {
        guard let url = URL(string: seed) else {
            completion(.failure(.invalidSeed))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        
        let requestDictionary: [String: Any?] = [
            "jsonrpc" : "2.0",
            "id"      : 4,
            "method"  : method.rawValue,
            "params"  : params ?? []
        ]
        
        guard let body = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
            completion(.failure(.invalidBodyRequest))
            return
        }
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionary else {
                completion(.failure(.invalidData))
                return
            }
            
            let result = NeoClientResult.success(json)
            completion(result)
        }
        task.resume()
    }
    
    func sendFullNodeRequest(_ url: String, params: [Any]?, completion :@escaping (NeoClientResult<JSONDictionary>) -> ()) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as! JSONDictionary else {
                completion(.failure(.invalidData))
                return
            }
            
            let result = NeoClientResult.success(json)
            completion(result)
        }
        task.resume()
    }
    
    public func getBestBlockHash(completion: @escaping (NeoClientResult<String>) -> ()) {
        sendRequest(.getBestBlockHash, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let hash = response["result"] as? String else {
                        completion(.failure(.invalidData))
                        return
                }
                let result = NeoClientResult.success(hash)
                completion(result)
            }
        }
    }
    
    public func getBlockBy(hash: String, completion: @escaping (NeoClientResult<Block>) -> ()) {
        sendRequest(.getBlock, params: [hash, 1]) { result in //figure out why you need the 1
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let block = try? decoder.decode(Block.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(block)
                completion(result)
            }
        }
    }
    
    public func getBlockBy(index: Int64, completion: @escaping (NeoClientResult<Block>) -> ()) {
        sendRequest(.getBlock, params: [index, 1]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let block = try? decoder.decode(Block.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(block)
                completion(result)
            }
        }
    }
    
    public func getBlockCount(completion: @escaping (NeoClientResult<Int64>) -> ()) {
        sendRequest(.getBlockCount, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let count = response["result"] as? Int64 else {
                    completion(.failure(.invalidData))
                    return
                }
                
                let result = NeoClientResult.success(count)
                completion(result)
            }
        }
    }
    
    public func getBlockHash(for index: Int64, completion: @escaping (NeoClientResult<String>) -> ()) {
        sendRequest(.getBlockHash, params: [index]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let hash = response["result"] as? String else {
                    completion(.failure(.invalidData))
                    return
                }
                
                let result = NeoClientResult.success(hash)
                completion(result)
            }
        }
    }
    
    public func getConnectionCount(completion: @escaping (NeoClientResult<Int64>) -> ()) {
        sendRequest(.getConnectionCount, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let count = response["result"] as? Int64 else {
                    completion(.failure(.invalidData))
                    return
                }
                
                let result = NeoClientResult.success(count)
                completion(result)
            }
        }
    }
    
    public func getTransaction(for hash: String, completion: @escaping (NeoClientResult<Transaction>) -> ()) {
        sendRequest(.getTransaction, params: [hash, 1]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let block = try? decoder.decode(Transaction.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(block)
                completion(result)
            }
        }
    }
    
    //NEED TO GUARD ON THE VALUE OUTS
    public func getTransactionOutput(with hash: String, and index: Int64, completion: @escaping (NeoClientResult<ValueOut>) -> ()) {
        sendRequest(.getTransaction, params: [hash, index]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let block = try? decoder.decode(ValueOut.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(block)
                completion(result)
            }
        }
    }
    
    public func getUnconfirmedTransactions(completion: @escaping (NeoClientResult<[String]>) -> ()) {
        sendRequest(.getUnconfirmedTransactions, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let txs = response["result"] as? [String] else {
                    completion(.failure(.invalidData))
                    return
                }
                
                let result = NeoClientResult.success(txs)
                completion(result)
            }
        }
    }
    
    public func getAssets(for address: String, params: [Any]?, completion: @escaping(NeoClientResult<Assets>) -> ()) {
        let url = apiURL.getBalance.rawValue + address
        sendFullNodeRequest(url, params: params) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let assets = try? decoder.decode(Assets.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(assets)
                completion(result)
            }
        }
    }
    
    public func sendRawTransaction(with data: Data, completion: @escaping(NeoClientResult<Bool>) -> ()) {
        sendRequest(.sendTransaction, params: [data.hexEncodedString()]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let success = response["result"] as? Bool else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(success)
                completion(result)
            }
        }
    }
}
