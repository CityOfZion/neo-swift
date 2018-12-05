//
//  Block.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 05/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc public class Block: NSObject, Codable {
    @objc public var version: UInt
    @objc public var txCount: UInt
    @objc public var transfers: [String]
    @objc public var transactions: [String]
    @objc public var time: UInt
    @objc public var size: UInt
    @objc public var script: BlockScript
    @objc public var previousblockhash: String
    @objc public var nonce: String
    @objc public var nextconsensus: String
    @objc public var nextblockhash: String
    @objc public var merkleroot: String
    @objc public var index: UInt
    @objc public var blockHash: String
    @objc public var confirmations: UInt
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case txCount = "tx_count"
        case transfers = "transfers"
        case transactions = "transactions"
        case time = "time"
        case size = "size"
        case script = "script"
        case previousblockhash = "previousblockhash"
        case nonce = "nonce"
        case nextconsensus = "nextconsensus"
        case nextblockhash = "nextblockhash"
        case merkleroot = "merkleroot"
        case index = "index"
        case blockHash = "hash"
        case confirmations = "confirmations"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version: UInt = try container.decode(UInt.self, forKey: .version)
        let txCount: UInt = try container.decode(UInt.self, forKey: .txCount)
        let transfers: [String] = try container.decode([String].self, forKey: .transfers)
        let transactions: [String] = try container.decode([String].self, forKey: .transactions)
        let time: UInt = try container.decode(UInt.self, forKey: .time)
        let size: UInt = try container.decode(UInt.self, forKey: .size)
        let script: BlockScript = try container.decode(BlockScript.self, forKey: .script)
        let previousblockhash: String = try container.decode(String.self, forKey: .previousblockhash)
        let nonce: String = try container.decode(String.self, forKey: .nonce)
        let nextconsensus: String = try container.decode(String.self, forKey: .nextconsensus)
        let nextblockhash: String = try container.decode(String.self, forKey: .nextblockhash)
        let merkleroot: String = try container.decode(String.self, forKey: .merkleroot)
        let index: UInt = try container.decode(UInt.self, forKey: .index)
        let blockHash: String = try container.decode(String.self, forKey: .blockHash)
        let confirmations: UInt = try container.decode(UInt.self, forKey: .confirmations)
        self.init(version: version, txCount: txCount, transfers: transfers, transactions: transactions, time: time, size: size, script: script, previousBlockHash: previousblockhash, nonce: nonce, nextConsensus: nextconsensus, nextBlockHash: nextblockhash, merkleroot: merkleroot, index: index, blockHash: blockHash, confirmations: confirmations)
    }
    
    public init(version: UInt, txCount: UInt, transfers: [String], transactions: [String], time: UInt, size: UInt, script: BlockScript, previousBlockHash: String, nonce: String, nextConsensus: String, nextBlockHash: String, merkleroot: String, index: UInt, blockHash: String, confirmations: UInt) {
        self.version = version
        self.txCount = txCount
        self.transfers = transfers
        self.transactions = transactions
        self.time = time
        self.size = size
        self.script = script
        self.previousblockhash = previousBlockHash
        self.nonce = nonce
        self.nextconsensus = nextConsensus
        self.nextblockhash = nextBlockHash
        self.merkleroot = merkleroot
        self.index = index
        self.blockHash = blockHash
        self.confirmations = confirmations
    }

}
