//
//  TransactionHistoryEntry.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 9/17/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct TransactionHistoryEntry: Codable {
    public var neo: Int
    public var gas: Double
    public var blockIndex: UInt64
    public var transactionID: String
    
    enum CodingKeys: String, CodingKey {
        case neo = "NEO"
        case gas = "GAS"
        case blockIndex = "block_index"
        case transactionID = "txid"
    }
    
    public init(neo: Int, gas: Double, blockIndex: UInt64, transactionID: String) {
        self.neo = neo
        self.gas = gas
        self.blockIndex = blockIndex
        self.transactionID = transactionID
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let neo: Int = try container.decode(Int.self, forKey: .neo)
        let gas: Double = try container.decode(Double.self, forKey: .gas)
        let blockIndex: UInt64 = try container.decode(UInt64.self, forKey: .blockIndex)
        let transactionID: String = try container.decode(String.self, forKey: .transactionID)
        self.init(neo: neo, gas: gas, blockIndex: blockIndex, transactionID: transactionID)
    }
}

public struct TransactionHistory: Codable {
    public var address: String
    public var net: String
    public var entries: [TransactionHistoryEntry]
    
    enum CodingKeys : String, CodingKey {
        case address = "address"
        case net = "net"
        case entries = "history"
    }
    
    public init(address: String, net: String, entries: [TransactionHistoryEntry]) {
        self.address = address
        self.net = net
        self.entries = entries
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address: String = try container.decode(String.self, forKey: .address)
        let net: String = try container.decode(String.self, forKey: .net)
        let entries: [TransactionHistoryEntry] = try container.decode([TransactionHistoryEntry].self, forKey: .entries)
        self.init(address: address, net: net, entries: entries)
    }
}
