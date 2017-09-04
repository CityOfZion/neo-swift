//
//  Block.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Block: Codable {
    var confirmations: Int64
    var hash: String
    var index: Int64
    var merkleRoot: String
    var nextBlockHash: String
    var nextConsensus: String
    var nonce: String
    var previousBlockHash: String
    var size: Int64
    var time: Int64
    var version: Int64
    var script: Script
    var transactions: [Transaction] 
    
    enum CodingKeys : String, CodingKey {
        case confirmations = "confirmations"
        case hash = "hash"
        case index = "index"
        case merkleRoot = "merkleroot"
        case nextBlockHash = "nextblockhash"
        case nextConsensus = "nextconsensus"
        case nonce = "nonce"
        case previousBlockHash = "previousblockhash"
        case size = "size"
        case time = "time"
        case version = "version"
        case script = "script"
        case transactions = "tx"
    }
    
    public init (confirmations: Int64, hash: String, index: Int64, merkleRoot: String, nextBlockHash: String, nextConsensus: String, nonce: String,
          previousBlockHash: String, size: Int64, time: Int64, version: Int64, script: Script, transactions: [Transaction]) {
        self.confirmations = confirmations
        self.hash = hash
        self.index = index
        self.merkleRoot = merkleRoot
        self.nextBlockHash = nextBlockHash
        self.nextConsensus = nextConsensus
        self.nonce = nonce
        self.previousBlockHash = previousBlockHash
        self.size = size
        self.time = time
        self.version = version
        self.script = script
        self.transactions = transactions
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let confirmations: Int64 = try container.decode(Int64.self, forKey: .confirmations)
        let hash: String = try container.decode(String.self, forKey: .hash)
        let index: Int64 = try container.decode(Int64.self, forKey: .index)
        let merkleRoot: String = try container.decode(String.self, forKey: .merkleRoot)
        let nextBlockHash: String = try container.decode(String.self, forKey: .nextBlockHash)
        let nextConsensus: String = try container.decode(String.self, forKey: .nextConsensus)
        let nonce: String = try container.decode(String.self, forKey: .nonce)
        let previousBlockHash: String = try container.decode(String.self, forKey: .previousBlockHash)
        let size: Int64 = try container.decode(Int64.self, forKey: .size)
        let time: Int64 = try container.decode(Int64.self, forKey: .time)
        let version: Int64 = try container.decode(Int64.self, forKey: .version)
        let script: Script = try container.decode(Script.self, forKey: .script)
        let transactions: [Transaction] = try container.decode([Transaction].self, forKey: .transactions)
        
        self.init(confirmations: confirmations, hash: hash, index: index, merkleRoot: merkleRoot, nextBlockHash: nextBlockHash, nextConsensus: nextConsensus,
                  nonce: nonce, previousBlockHash: previousBlockHash, size: size, time: time, version: version, script: script, transactions: transactions)
    }
}
