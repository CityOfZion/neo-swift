//
//  NeoClient.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import Neoutils

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
    public var network: Network = .test
    public var seed = "http://seed3.o3node.org:10332"
    public var fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v2/"
    public static let sharedTest = NeoClient(network: .test)
    public static let sharedMain = NeoClient(network: .main)
    private init() {}
    private let tokenInfoCache = NSCache<NSString, AnyObject>()
    
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
        case invokeFunction = "invokefunction"
        case invokeContract = "invokescript"
        //The following routes can't be invoked by calling an RPC server
        //We must use the wrapper for the nodes made by COZ
        case getBalance = "getbalance"
    }
    
    enum NEP5Method: String {
        case balanceOf = "balanceOf"
        case decimal = "decimal"
        case symbol = "symbol"
    }
    
    enum apiURL: String {
        case getUTXO = "utxo"
        case getClaims = "claimablegas"
        case getTransactionHistory = "address/history/"
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
            fullNodeAPI = "https://platform.o3.network/api/v1/neo/"
            seed = "http://seed1.neo.org:10332"
        case .privateNet:
            fullNodeAPI = "http://127.0.0.1:5000/"
            seed = "http://localhost:30333"
        }
    }
    
    public init(network: Network, seedURL: String) {
        self.network = network
        switch self.network {
        case .test:
            fullNodeAPI = "http://testnet-api.wallet.cityofzion.io/v2/"
            seed = seedURL
        case .main:
            fullNodeAPI = "https://platform.o3.network/api/v1/neo/"
            seed = seedURL
        case .privateNet:
            fullNodeAPI = "http://127.0.0.1:5000/"
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
        request.timeoutInterval = 60
        
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
        let url = fullNodeAPI + address + "/" + apiURL.getUTXO.rawValue
        sendFullNodeRequest(url, params: params) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                guard let data = try? JSONSerialization.data(withJSONObject: response["result"], options: .prettyPrinted),
                    let assets = try? decoder.decode(Assets.self, from: data) else {
                        completion(.failure(.invalidData))
                        return
                }
                
                let result = NeoClientResult.success(assets)
                completion(result)
            }
        }
    }
    
    public func getClaims(address: String, completion: @escaping(NeoClientResult<Claimable>) -> ()) {
        let url = fullNodeAPI + address + "/" + apiURL.getClaims.rawValue
        sendFullNodeRequest(url, params: nil) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                let decoder = JSONDecoder()
                
                guard let data = try? JSONSerialization.data(withJSONObject: (response["result"] as? JSONDictionary)!["data"], options: .prettyPrinted),
                    let claims = try? decoder.decode(Claimable.self, from: data) else {
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
                if response["result"] == nil {
                    completion(.failure(NeoClientError.invalidData))
                    return
                }
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
        let cacheKey: NSString = scriptHash as NSString
        if let tokenInfo = tokenInfoCache.object(forKey: cacheKey) as? NEP5Token {
            completion(.success(tokenInfo))
            return
        }
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
                self.tokenInfoCache.setObject(token as AnyObject, forKey: cacheKey)
                completion(.success(token))
            }
        }
    }
    
    public func getTokenBalance(_ scriptHash: String, address: String, completion: @escaping(NeoClientResult<Double>) -> ()) {
        let scriptBuilder = ScriptBuilder()
        let cacheKey: NSString = scriptHash as NSString
        guard let tokenInfo = tokenInfoCache.object(forKey: cacheKey) as? NEP5Token else {
            //Token info not in cache then fetch it.
            self.getTokenInfo(with: scriptHash, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success:
                    self.getTokenBalance(scriptHash, address: address, completion: completion)
                    return
                }
            })
            return
        }
        
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "balanceOf", args: [address.hashFromAddress()])
        self.invokeContract(with: scriptBuilder.rawHexString) { contractResult in
            switch contractResult {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                #if DEBUG
                print(response)
                #endif
                let balanceData = response.stack[0].hexDataValue ?? ""
                if balanceData == "" {
                    completion(.success(0))
                    return
                }
                
                let balance = Double(balanceData.littleEndianHexToUInt)
                let divider = pow(Double(10), Double(tokenInfo.decimals))
                let amount = balance / divider
                completion(.success(amount))
            }
        }
    }
    
    public func getTokenBalanceUInt(_ scriptHash: String, address: String, completion: @escaping(NeoClientResult<UInt>) -> ()) {
        let scriptBuilder = ScriptBuilder()
        
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "balanceOf", args: [address.hashFromAddress()])
        self.invokeContract(with: scriptBuilder.rawHexString) { contractResult in
            switch contractResult {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                #if DEBUG
                print(response)
                #endif
                let balanceData = response.stack[0].hexDataValue ?? ""
                if balanceData == "" {
                    completion(.success(0))
                    return
                }
                let balance = balanceData.littleEndianHexToUInt
                completion(.success(balance))
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
    
    
    public func getTokenSaleStatus(for address: String, scriptHash: String, completion: @escaping(NeoClientResult<Bool>) -> ()) {
        let scriptBuilder = ScriptBuilder()
        scriptBuilder.pushContractInvoke(scriptHash: scriptHash, operation: "kycStatus", args: [address.hashFromAddress()])
        self.invokeContract(with: scriptBuilder.rawHexString) { contractResult in
            switch contractResult {
            case .failure(let error):
                completion(.failure(error))
            case .success(let response):
                #if DEBUG
                print(response)
                #endif
                let whitelisted = response.stack[0].hexDataValue
                if whitelisted == "" {
                    completion(.success(false))
                    return
                }
                if whitelisted == "01" {
                    completion(.success(true))
                    return
                }
                completion(.success(false))
            }
        }
    }
}
