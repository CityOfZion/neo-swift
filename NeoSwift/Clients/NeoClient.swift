//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils

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

public enum Network: String {
    case test
    case main
    case privateNet
}

public class NEONetworkMonitor {
    private init() {
        self.network =  self.load()
    }
    public static let sharedInstance = NEONetworkMonitor()
    public var network: NEONetwork?
    
    private func load() -> NEONetwork? {
        guard let path = Bundle(for: type(of: self)).path(forResource: "nodes", ofType: "json") else {
            return nil
        }
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = JSONDecoder()
        
        guard let json = try? JSONSerialization.jsonObject(with: fileData, options: []) as! JSONDictionary else {
            return nil
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let result = try? decoder.decode(NEONetwork.self, from: data) else {
                return nil
        }
        return result
    }
    
    public static func autoSelectBestNode() -> String? {
        let networks = NEONetworkMonitor().load()
        let nodes = networks?.mainNet.nodes.map({$0.URL}).joined(separator: ",")
        guard let bestNode =  NeoutilsSelectBestSeedNode(nodes) else {
            return nil
        }
        return bestNode.url()
    }
    
}

public class NeoClient {
    
    public var seed = "http://seed3.o3node.org:10332"
    
    private init() {}
    private let tokenInfoCache = NSCache<NSString, AnyObject>()
    
    enum RPCMethod: String {
        case getBlockCount = "getblockcount"
        case getConnectionCount = "getconnectioncount"
        case getAccountState = "getaccountstate"
        case getAssetState = "getassetstate"
        case sendTransaction = "sendrawtransaction"
        case invokeContract = "invokescript"
        case getMemPool = "getrawmempool"
    }
    
    public init(seed: String) {
        self.seed = seed
    }
    
    func sendJSONRPCRequest(_ method: RPCMethod, params: [Any]?, completion: @escaping (NeoClientResult<JSONDictionary>) -> Void) {
        guard let url = URL(string: seed) else {
            completion(.failure(.invalidSeed))
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let requestDictionary: [String: Any?] = [
            "jsonrpc": "2.0",
            "id": 2,
            "method": method.rawValue,
            "params": params ?? []
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
            
            if data == nil {
                completion(.failure(.invalidData))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? JSONDictionary else {
                completion(.failure(.invalidData))
                return
            }
            
            if json == nil {
                completion(.failure(.invalidData))
                return
            }
            
            let resultJson = NeoClientResult.success(json!)
            completion(resultJson)
        }
        task.resume()
    }
    
    public func sendRawTransaction(with data: Data, completion: @escaping(NeoClientResult<Bool>) -> Void) {
        sendJSONRPCRequest(.sendTransaction, params: [data.fullHexString]) { result in
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
    
    public func getMempoolHeight(completion: @escaping(NeoClientResult<Int>) -> Void) {
        sendJSONRPCRequest(.getMemPool, params: []) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let mempool = response["result"] as? [String] else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(mempool.count)
                completion(result)
            }
        }
    }
    
    public func getBlockCount(completion: @escaping (NeoClientResult<Int64>) -> ()) {
        sendJSONRPCRequest(.getBlockCount, params: []) { result in
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
    
    public func getAccountState(for address: String, completion: @escaping(NeoClientResult<AccountState>) -> ()) {
        sendJSONRPCRequest(.getAccountState, params: [address]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let accountState = try? decoder.decode(AccountState.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(accountState)
                completion(result)
            }
        }
    }
    
    public func getAssetState(for asset: String, completion: @escaping(NeoClientResult<AssetState>) -> ()) {
        sendJSONRPCRequest(.getAssetState, params: [asset]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let assetState = try? decoder.decode(AssetState.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(assetState)
                completion(result)
            }
        }
    }
}
