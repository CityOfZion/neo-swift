//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils

@objc public enum NeoClientErrorType: Int {
    case invalidSeed, invalidBodyRequest, invalidData, invalidRequest, noInternet
}

@objc public class NeoClientError: NSObject {
    @objc var errorType: NeoClientErrorType
    
    @objc public init(_ errorType: NeoClientErrorType) {
        self.errorType = errorType
    }
    
    @objc var localizedDescription: String {
        switch self.errorType {
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
        default:
            return "Unexpected error"
        }
    }
    
}

@objc public enum Network: Int {
    case test
    case main
    case privateNet
}

@objc public class NEONetworkMonitor: NSObject {
    private override init() {
        super.init()
        self.network =  self.load()
    }
    @objc public static let sharedInstance = NEONetworkMonitor()
    @objc public var network: NEONetwork?
    
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
    
    @objc public static func autoSelectBestNode() -> String? {
        let networks = NEONetworkMonitor().load()
        let nodes = networks?.mainNet.nodes.map({$0.URL}).joined(separator: ",")
        guard let bestNode =  NeoutilsSelectBestSeedNode(nodes) else {
            return nil
        }
        return bestNode.url()
    }
    
    @objc public static func autoSelectTestBestNode() -> String? {
        let networks = NEONetworkMonitor().load()
        let nodes = networks?.testNet.nodes.map({$0.URL}).joined(separator: ",")
        guard let bestNode =  NeoutilsSelectBestSeedNode(nodes) else {
            return nil
        }
        return bestNode.url()
    }
}

@objc public class NeoClient : NSObject {
    
    @objc public var seed = "http://seed3.o3node.org:10332"
    
    private let tokenInfoCache = NSCache<NSString, AnyObject>()
    
    enum RPCMethod: String {
        case getBlockCount = "getblockcount"
        case sendTransaction = "sendrawtransaction"
        case invokeContract = "invokescript"
        case getMemPool = "getrawmempool"
    }
    
    @objc public init(seed: String) {
        self.seed = seed
    }
    
    func sendJSONRPCRequest(_ method: RPCMethod, params: [Any]?, completion: @escaping (JSONDictionary?, NeoClientError?) -> Void) {
        guard let url = URL(string: seed) else {
            completion(nil, NeoClientError(.invalidSeed))
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
            completion(nil, NeoClientError(.invalidBodyRequest))
            return
        }
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, err) in
            if err != nil {
                completion(nil, NeoClientError(.invalidRequest))
                return
            }
            
            if data == nil {
                completion(nil, NeoClientError(.invalidData))
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
    
    @objc public func sendRawTransaction(with data: Data, completion: @escaping(Bool, NeoClientError?) -> Void) {
        sendJSONRPCRequest(.sendTransaction, params: [data.fullHexString]) { json, error in
            if let response = json {
                guard let success = response["result"] as? Bool else {
                    completion(false, NeoClientError(.invalidData))
                    return
                }
                completion(success, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    
    @objc public func getTokenInfo(with scriptHash: String, completion: @escaping(NEP5Token?, NeoClientError?) -> ()) {
        let cacheKey: NSString = scriptHash as NSString
        if let tokenInfo = tokenInfoCache.object(forKey: cacheKey) as? NEP5Token {
            completion(tokenInfo, nil)
            return
        }
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "name")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "symbol")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "decimals")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "totalSupply")
        invokeContract(with: scriptBuilder.rawHexString) { result, error in
            if let contractResult = result {
                guard let token = NEP5Token(from: contractResult.stack) else {
                    completion(nil, NeoClientError(.invalidData))
                    return
                }
                self.tokenInfoCache.setObject(token as AnyObject, forKey: cacheKey)
                completion(token, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    @objc public func invokeContract(with script: String, completion: @escaping(ContractResult?, NeoClientError?) -> ()) {
        sendJSONRPCRequest(.invokeContract, params: [script]) { (json, error) in
            if let response = json {
                let decoder = JSONDecoder()
                if response["result"] == nil {
                    completion(nil, NeoClientError(.invalidData))
                    return
                }
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    
                    let contractResult = try? decoder.decode(ContractResult.self, from: data) else {
                        completion(nil, NeoClientError(.invalidData))
                        return
                }
                
                completion(contractResult, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    @objc public func getTokenBalance(_ scriptHash: String, address: String, completion: @escaping(Double, NeoClientError?) -> ()) {
        let scriptBuilder = ScriptBuilder()
        let cacheKey: NSString = scriptHash as NSString
        guard let tokenInfo = tokenInfoCache.object(forKey: cacheKey) as? NEP5Token else {
            //Token info not in cache then fetch it.
            self.getTokenInfo(with: scriptHash) { (token, error) in
                if let errorResult = error {
                    completion(0, errorResult)
                }
                else {
                    self.getTokenBalance(scriptHash, address: address, completion: completion)
                }
            }
            return
        }
        
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "balanceOf", args: [address.hashFromAddress()])
        self.invokeContract(with: scriptBuilder.rawHexString) { result, error in
            if let response = result {
                #if DEBUG
                print(response)
                #endif
                let balanceData = response.stack[0].hexDataValue ?? ""
                if balanceData == "" {
                    completion(0, nil)
                    return
                }
                
                let balance = Double(balanceData.littleEndianHexToUInt)
                let divider = pow(Double(10), Double(tokenInfo.decimals))
                let amount = balance / divider
                completion(amount, nil)
            }
            else {
                completion(0, error)
            }
        }
    }
}
