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

public enum Network: String {
    case test
    case main
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
    
}

public class NeoClient {
    public var network: Network = .test
    public var seed = "http://seed1.neo.org:10332"
    public var fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v2/"
    public static let sharedTest = NeoClient(network: .test)
    public static let sharedMain = NeoClient(network: .main)
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
        case validateAddress = "validateaddress"
        case getAccountState = "getaccountstate"
        case getAssetState = "getassetstate"
        case getPeers = "getpeers"
        //The following routes can't be invoked by calling an RPC server
        //We must use the wrapper for the nodes made by COZ
        case getBalance = "getbalance"
        case invokeContract = "invokescript"
    }
    
    enum apiURL: String {
        case getBalance = "address/balance/"
        case getClaims = "address/claims/"
        case getTransactionHistory = "address/history/"
        case getBestNode = "network/best_node"
    }
    
    public init(seed: String) {
        self.seed = seed
    }
    
    public init(network: Network) {
        self.network = network
        switch self.network {
        case .test:
            fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v2/"
            seed = "http://test4.cityofzion.io:8880"
        case .main:
            fullNodeAPI = "http://api.wallet.cityofzion.io/v2/"
            seed = "http://seed1.neo.org:10332"
        }
    }
    
    public init(network: Network, seedURL: String) {
        self.network = network
        switch self.network {
        case .test:
            fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v2/"
            seed = seedURL
        case .main:
            fullNodeAPI = "http://api.wallet.cityofzion.io/v2/"
            seed = seedURL
        }
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
            "id"      : 2,
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
    
    public func getPeers(completion:  @escaping (NeoClientResult<GetPeersResult>) -> ()) {
        sendRequest(.getPeers, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let block = try? decoder.decode(GetPeersResult.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(block)
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
        let url = fullNodeAPI + apiURL.getBalance.rawValue + address
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
    
    public func getClaims(address: String, completion: @escaping(NeoClientResult<Claims>) -> ()) {
        let url = fullNodeAPI + apiURL.getClaims.rawValue + address
        sendFullNodeRequest(url, params: nil) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let claims = try? decoder.decode(Claims.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(claims)
                completion(result)
            }
        }
    }
    
    public func getTransactionHistory(for address: String, completion: @escaping (NeoClientResult<TransactionHistory>) -> ()) {
        let url = fullNodeAPI + apiURL.getTransactionHistory.rawValue + address
        sendFullNodeRequest(url, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                    let history = try? decoder.decode(TransactionHistory.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(history)
                completion(result)
            }
        }
    }
    
    public func sendRawTransaction(with data: Data, completion: @escaping(NeoClientResult<Bool>) -> ()) {
        sendRequest(.sendTransaction, params: [data.fullHexString]) { result in
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
    
    public func validateAddress(_ address: String, completion: @escaping(NeoClientResult<Bool>) -> ()) {
        sendRequest(.validateAddress, params: [address]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let jsonResult: [String: Any] = response["result"] as? JSONDictionary else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let isValid = jsonResult["isvalid"] as? Bool else {
                    completion(.failure(.invalidData))
                    return
                }
                
                let result = NeoClientResult.success(isValid)
                completion(result)
            }
        }
    }
    
    public func getAccountState(for address: String, completion: @escaping(NeoClientResult<AccountState>) -> ()) {
        sendRequest(.getAccountState, params: [address]) { result in
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
    
    public func invokeContract(with script: String, completion: @escaping(NeoClientResult<ContractResult>) -> ()) {
        sendRequest(.invokeContract, params: [script]) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                print (response)
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as! JSONDictionary), options: .prettyPrinted),
                    let contractResult = try? decoder.decode(ContractResult.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(contractResult)
                completion(result)
            }
        }
    }
    
    public func getTokenInfo(with scriptHash: String, completion: @escaping(NeoClientResult<NEP5Token>) -> ()) {
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "name")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "symbol")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "decimals")
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "totalSupply")
        invokeContract(with: scriptBuilder.rawHexString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let contractResult):
                guard let token = NEP5Token(from: contractResult.stack) else {
                    completion(.failure(.invalidData))
                    return
                }
                completion(.success(token))
            }
        }
    }
    
    public func getTokenBalance(_ token: String, address: String, completion: @escaping(NeoClientResult<Int>) -> ()) {
        let scriptBuilder = ScriptBuilder()
        guard let tokenScriptHash = NEP5Token.tokens[token] else {
            completion(.success(0))
            return
        }
        
        scriptBuilder.pushContractInvoke(scriptHash: tokenScriptHash, operation: "balanceOf", args: [address.hashFromAddress()])
        print (scriptBuilder.rawHexString)
        NeoClient(network: network).invokeContract(with: scriptBuilder.rawHexString) { contractResult in
            switch contractResult {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let balanceData = response.stack[0].hexDataValue ?? ""
                if balanceData == "" {
                    completion(.success(0))
                    return
                }
                let balance = UInt64(littleEndian: balanceData.dataWithHexString().withUnsafeBytes { $0.pointee })
                completion(.success(Int(balance / 100000000)))
            }
        }
    }

    
    public func getAssetState(for asset: String, completion: @escaping(NeoClientResult<AssetState>) -> ()) {
        sendRequest(.getAssetState, params: [asset]) { result in
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
    
    public func getBestNode(completion: @escaping (NeoClientResult<String>) -> ()) {
        let url = fullNodeAPI + apiURL.getBestNode.rawValue
        sendFullNodeRequest(url, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                guard let node = response["node"] as? String else {
                    completion(.failure(.invalidData))
                    return
                }
                let result = NeoClientResult.success(node)
                completion(result)
            }
        }
    }
}
