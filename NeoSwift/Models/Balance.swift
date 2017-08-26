//
//  Balance.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Unspent: Codable {
    var index: Int
    var txId: String
    var value: Double
    
    enum CodingKeys: String, CodingKey {
        case index = "index"
        case txId = "txid"
        case value = "value"
    }
    
    public init(index: Int, txId: String, value: Double) {
        self.index = index
        self.txId = txId
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let index: Int = try container.decode(Int.self, forKey: .index)
        let txId: String = try container.decode(String.self, forKey: .txId)
        let value: Double = try container.decode(Double.self, forKey: .value)
        self.init(index: index, txId: txId, value: value)
    }
}

public struct Gas: Codable {
    var balance: Double
    var unspent: [Unspent]
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case unspent = "unspent"
    }
    
    public init(balance: Double, unspent: [Unspent]) {
        self.balance = balance
        self.unspent = unspent
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let balance: Double = try container.decode(Double.self, forKey: .balance)
        let unspent: [Unspent] = try container.decode([Unspent].self, forKey: .unspent)
        self.init(balance: balance, unspent: unspent)
    }
}

public struct Neo: Codable {
    var balance: Double
    var unspent: [Unspent]
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case unspent = "unspent"
    }
    
    public init(balance: Double, unspent: [Unspent]) {
        self.balance = balance
        self.unspent = unspent
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let balance: Double = try container.decode(Double.self, forKey: .balance)
        let unspent: [Unspent] = try container.decode([Unspent].self, forKey: .unspent)
        self.init(balance: balance, unspent: unspent)
    }
}

public struct Balance: Codable {
    var gas: Gas
    var neo: Neo
    var address: String
    var net: String
    
    enum CodingKeys: String, CodingKey {
        case gas = "GAS"
        case neo = "NEO"
        case address = "address"
        case net = "net"
    }
    
    public init(gas: Gas, neo: Neo, address: String, net: String) {
        self.gas = gas
        self.neo = neo
        self.address = address
        self.net = net
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gas: Gas = try container.decode(Gas.self, forKey: .gas)
        let neo: Neo = try container.decode(Neo.self, forKey: .neo)
        let address: String = try container.decode(String.self, forKey: .address)
        let net: String = try container.decode(String.self, forKey: .net)
        self.init(gas: gas, neo: neo, address: address, net: net)
    }
    
    public func getInputsNecessaryToSendAsset(asset: AssetId, amount: Double) -> (Double?, Data?, Error?){
        var sortedUnspents = [Unspent]()
        var neededForTransaction = [Unspent]()
        if asset == .neoAssetId {
            if neo.balance < amount {
                return (nil, nil, NSError())
            }
            sortedUnspents = neo.unspent.sorted {$0.value < $1.value }
        } else {
            if gas.balance < amount {
                return (nil, nil, NSError())
            }
            sortedUnspents = neo.unspent.sorted { $0.value < $1.value }
        }
        var runningAmount = 0.0
        var index = 0
        var count: UInt8 = 0
        //Assume we always have anough balance to do this, prevent the check for bal
        while runningAmount < amount {
            neededForTransaction.append(sortedUnspents[index])
            runningAmount = runningAmount + sortedUnspents[index].value
            index = index + 1
            count = count + 1
        }
        var inputData = [UInt8]()
        inputData.append(count)
        for x in 0..<neededForTransaction.count {
            let data = neededForTransaction[x].txId.dataWithHexString()
            let reversedBytes = data.bytes.reversed()
            inputData = inputData + reversedBytes + [0x00, 0x00, 0x00, UInt8(neededForTransaction[x].index)]
        }
        
        return (runningAmount, Data(bytes: inputData), nil)
    }
    
    func getTransactionPayload(asset: AssetId, with inputData: Data, runningAmount: Double, toSendAmount: Double, hashedSignature: Data) {
        var inputDataBytes = inputData.bytes
        var needsTwoOutputTransactions = runningAmount != toSendAmount
        var payloadLength = needsTwoOutputTransactions ? inputDataBytes.count + 128 : inputDataBytes.count + 64
        var payload: [UInt8] = [0x80, 0x00, 0x00]
        payload = payload + inputDataBytes
        if needsTwoOutputTransactions {
            payload = payload + [0x02] + asset.rawValue.dataWithHexString().bytes.reversed()
            var amountToSendInMemory = UInt64(toSendAmount * 100000000)
            payload = payload + toByteArray(amountToSendInMemory)
            var amountToGetBackInMemory = UInt64((runningAmount - toSendAmount) * 100000000)
            payload = payload + toByteArray(amountToGetBackInMemory)
            payload = payload + hashedSignature.bytes
        } else {
            payload = payload + [0x01] + asset.rawValue.dataWithHexString().bytes.reversed()
            var amountToSendInMemory = UInt64(toSendAmount * 100000000)
            payload = payload + toByteArray(amountToSendInMemory)
            payload = payload + hashedSignature.bytes   
        }
    }
}



