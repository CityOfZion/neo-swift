//
//  Balance.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Balance: NSObject, Codable {
    @objc public var unspent: [Unspent]
    @objc public var asset_symbol: String
    @objc public var asset_hash: String
    @objc public var asset: String
    @objc public var amount: Double
    
    enum CodingKeys: String, CodingKey {
        case unspent
        case asset_symbol
        case asset_hash
        case asset
        case amount
    }
    
    public init(unspent: [Unspent], asset_symbol: String, asset_hash: String, asset: String, amount: Double) {
        self.unspent = unspent
        self.asset_symbol = asset_symbol
        self.asset_hash = asset_hash
        self.asset = asset
        self.amount = amount
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unspent: [Unspent] = try container.decode([Unspent].self, forKey: .unspent)
        let asset_symbol: String = try container.decode(String.self, forKey: .asset_symbol)
        let asset_hash: String = try container.decode(String.self, forKey: .asset_hash)
        let asset: String = try container.decode(String.self, forKey: .asset)
        let amount: Double = try container.decode(Double.self, forKey: .amount)
        self.init(unspent: unspent, asset_symbol: asset_symbol, asset_hash: asset_hash, asset: asset, amount: amount)
    }

}

@objc public class BalanceResponse: NSObject, Codable {
    @objc public var balance: [Balance]
    @objc public var address: String
    
    enum CodingKeys: String, CodingKey {
        case balance
        case address
    }
    
    public init(balance: [Balance], address: String) {
        self.balance = balance
        self.address = address
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let balance: [Balance] = try container.decode([Balance].self, forKey: .balance)
        let address: String = try container.decode(String.self, forKey: .address)
        self.init(balance: balance, address: address)
    }
}
