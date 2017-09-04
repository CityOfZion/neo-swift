//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public class NeoClient {
    public var seed = "http://seed4.neo.org:10332"
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
        case sendTransaction = "sendrawransaction"
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
    
    func sendRequest(_ method: RPCMethod, params: [Any]?, completion :@escaping ([String:AnyObject]?, Error?) -> Void) {
        guard let url = URL(string: seed) else {
            completion(nil, "Invalid Seed" as? Error)
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        
        let requestDictionary: [String: Any?] = [
            "jsonrpc" : "2.0",
            "id"      : 1,
            "method"  : method.rawValue,
            "params"  : params ?? []
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: requestDictionary, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(nil, err)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                completion(nil, "Some Error" as? Error)
                return
            }
            
            completion(json, nil)
        }
        task.resume()
    }
    
    func sendFullNodeRequest(_ url: String, params: [Any]?, completion :@escaping ([String:AnyObject]?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(nil, err)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] else {
                completion(nil, "Some Error" as? Error)
                return
            }
            
            completion(json, nil)
        }
        task.resume()
    }
    
    public func getBestBlockHash(completion: @escaping (String?, Error?) -> Void) {
        sendRequest(.getBestBlockHash, params: nil) { json, error in
            guard error == nil,
                let hash = json?["result"] as? String else {
                    completion(nil, error)
                    return
            }
            completion(hash, nil)
            return
        }
    }
    
    public func getBlockBy(hash: String, completion: @escaping (Block?, Error?) -> Void) {
        sendRequest(.getBlock, params: [hash, 1]) { json, error in //figure out why you need the 1
            let decoder = JSONDecoder()
            guard error == nil else {
                completion(nil, error)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: (json!["result"] as! [String: Any]), options: .prettyPrinted)
            let block = try! decoder.decode(Block.self, from: data)
            completion(block, error)
        }
    }
    
    public func getBlockBy(index: Int64, completion: @escaping (Block?, Error?) -> Void) {
        sendRequest(.getBlock, params: [index, 1]) { json, error in
            let decoder = JSONDecoder()
            guard error == nil else {
                completion(nil, error)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: (json!["result"] as! [String: Any]), options: .prettyPrinted)
            let block = try! decoder.decode(Block.self, from: data)
            completion(block, error)
        }
    }
    
    public func getBlockCount(completion: @escaping (Int64?, Error?) -> Void) {
        sendRequest(.getBlockCount, params: nil) { json, error in
            guard error == nil,
                let count = json?["result"] as? Int64 else {
                    completion(nil, error)
                    return
            }
            completion(count, error)
            return
        }
    }
    
    public func getBlockHash(for index: Int64, completion: @escaping (String?, Error?) -> Void) {
        sendRequest(.getBlockHash, params: [index]) { json, error in
            guard error == nil,
                let hash = json?["result"] as? String else {
                    completion(nil, error)
                    return
            }
            completion(hash, error)
            return
        }
    }
    
    public func getConnectionCount(completion: @escaping (Int64?, Error?) -> Void) {
        sendRequest(.getConnectionCount, params: nil) { json, error in
            guard error == nil,
                let count = json?["result"] as? Int64 else {
                    completion(nil, error)
                    return
            }
            completion(count, error)
            return
        }
    }
    
    public func getTransaction(for hash: String, completion: @escaping (Transaction?, Error?) -> Void) {
        sendRequest(.getTransaction, params: [hash, 1]) { json, error in
            let decoder = JSONDecoder()
            guard error == nil else {
                completion(nil, error)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: (json!["result"] as! [String: Any]), options: .prettyPrinted)
            let transaction = try! decoder.decode(Transaction.self, from: data)
            completion(transaction, error)
        }
    }
    
    //NEED TO GUARD ON THE VALUE OUTS
    public func getTransactionOutput(with hash: String, and index: Int64, completion: @escaping (ValueOut?, Error?) -> Void) {
        sendRequest(.getTransaction, params: [hash, index]) { json, error in
            let decoder = JSONDecoder()
            guard error == nil else {
                completion(nil, error)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: (json!["result"]), options: .prettyPrinted)
            let transaction = try! decoder.decode(ValueOut.self, from: data)
            completion(transaction, error)
        }
    }
    
    public func getUnconfirmedTransactions(completion: @escaping ([String]?, Error?) -> Void) {
        sendRequest(.getUnconfirmedTransactions, params: nil) { json, error in
            guard error == nil,
                let count = json?["result"] as? [String] else {
                    completion(nil, error)
                    return
            }
            completion(count, error)
            return
        }
    }
    
    public func getAssets(for address: String, params: [Any]?, completion: @escaping(Assets?, Error?) -> Void) {
        //test address AJs38kijktEuM22sjfXqfjZ734RqR4H6JW
        let url = apiURL.getBalance.rawValue + address
        sendFullNodeRequest(url, params: params) { json, error in
            let decoder = JSONDecoder()
            guard error == nil else {
                completion(nil, error)
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: json!, options: .prettyPrinted)
            let balance = try! decoder.decode(Assets.self, from: data)
            completion(balance, nil)

        }
    }
    
    
    public func sendRawTransaction(with data: Data, completion: @escaping([String]?, Error?) -> Void) {
        sendRequest(.sendTransaction, params: [data.hexEncodedString()]) { json, error in
            guard error == nil else {
                completion(nil, nil)
                return
            }
            completion(nil, nil)
        }
    }
}
