//
//  Balance.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Unspent: Codable {
    public var index: Int
    public var txId: String
    public var value: Double
    
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
    public var balance: Double
    public var unspent: [Unspent]
    
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
    public var balance: Double
    public var unspent: [Unspent]
    
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

public struct Assets: Codable {
    public var gas: Gas
    public var neo: Neo
    public var address: String
    public var net: String
    
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
}
