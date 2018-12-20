//
//  NeoScanBaseModel.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class NeoScanBaseModel: NSObject, Codable {
    @objc public var value: Double
    @objc public var txid: String
    @objc public var n: Int
    @objc public var asset: String
    @objc public var address_hash: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case txid
        case n
        case asset
        case address_hash
    }
    
    public init(value: Double, txid: String, n: Int, asset: String, address_hash: String) {
        self.value = value
        self.txid = txid
        self.n = n
        self.asset = asset
        self.address_hash = address_hash
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value: Double = try container.decode(Double.self, forKey: .value)
        let txid: String = try container.decode(String.self, forKey: .txid)
        let n: Int = try container.decode(Int.self, forKey: .n)
        let asset: String = try container.decode(String.self, forKey: .asset)
        let address_hash: String = try container.decode(String.self, forKey: .address_hash)
        self.init(value: value, txid: txid, n: n, asset: asset, address_hash: address_hash)
    }

}
