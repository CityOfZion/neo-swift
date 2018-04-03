//
//  NeoScanBalance.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

public struct NeoScanGetBalance: Codable {
    let balance: [Balance]
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case address = "address"
    }
}

struct Balance: Codable {
    let unspent: [NeoScanUnspent]
    let asset: String
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case unspent = "unspent"
        case asset = "asset"
        case amount = "amount"
    }
}

struct NeoScanUnspent: Codable {
    let value: Double
    let txid: String
    let n: Int

    enum CodingKeys: String, CodingKey {
        case value = "value"
        case txid = "txid"
        case n = "n"
    }
}

