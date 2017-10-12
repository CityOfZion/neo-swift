//
//  Claim.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 9/9/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Claim: Codable {
    var claim: Int
    var end: Int
    var index: UInt16
    var start: Int
    var sysFee: Int
    var txId: String
    var value: Int
    
    
    enum CodingKeys: String, CodingKey {
        case claim = "claim"
        case end = "end"
        case index = "index"
        case start = "start"
        case sysFee = "sysfee"
        case txId = "txid"
        case value = "value"
    }
    
    public init(claim: Int, end: Int, index: UInt16, start: Int, sysFee: Int, txId: String, value: Int) {
        self.claim = claim
        self.end = end
        self.index = index
        self.start = start
        self.sysFee = sysFee
        self.txId = txId
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let claim: Int = try container.decode(Int.self, forKey: .claim)
        let end: Int = try container.decode(Int.self, forKey: .end)
        let index: UInt16 = try container.decode(UInt16.self, forKey: .index)
        let start: Int = try container.decode(Int.self, forKey: .start)
        let sysFee: Int = try container.decode(Int.self, forKey: .sysFee)
        let txId: String = try container.decode(String.self, forKey: .txId)
        let value: Int = try container.decode(Int.self, forKey: .value)
        self.init(claim: claim, end: end, index: index, start: start, sysFee: sysFee, txId: txId, value: value)
    }
}
