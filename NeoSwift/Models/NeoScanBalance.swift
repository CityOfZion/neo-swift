//
//  NeoScanBalance.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

public struct NeoScanGetBalance: Codable {
    public let balance: [Balance]
    public let address: String
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case address = "address"
    }
}

public struct Balance: Codable {
    public let unspent: [NeoScanUnspent]
    public let asset: String
    public let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case unspent = "unspent"
        case asset = "asset"
        case amount = "amount"
    }
}

public struct NeoScanUnspent: Codable {
    public let value: Double
    public let txid: String
    public let n: Int

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case txid = "txid"
        case n = "n"
    }
}
