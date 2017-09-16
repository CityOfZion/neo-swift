//
//  TransactionHistoryEntry.swift
//  NeoSwift
//
//  Created by Luís Silva on 16/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct TransactionHistoryEntry: Codable {
    public var neo: Double
    public var gas: Double
    public var blockIndex: UInt64
    public var txId: String
    
    enum CodingKeys : String, CodingKey {
        case neo = "NEO"
        case gas = "GAS"
        case blockIndex = "block_index"
        case txId = "txid"
    }
    
}
