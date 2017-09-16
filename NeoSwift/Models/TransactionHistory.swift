//
//  TransactionHistory.swift
//  NeoSwift
//
//  Created by Luís Silva on 16/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct TransactionHistory: Codable {
    public var address: String
    public var net: String
    public var entries: [TransactionHistoryEntry]
    
    enum CodingKeys : String, CodingKey {
        case address = "address"
        case net = "net"
        case entries = "history"
    }
}
