//
//  ValueOut.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct ValueOut: Codable {
    public var n: Int
    public var asset: String
    public var value: String
    public var address: String
    
    enum CodingKeys: String, CodingKey {
        case n = "n" // need clarification on this value better naming over all would be good
        case asset = "asset"
        case value = "value"
        case address = "address"
    }
    
    public init(n: Int, asset: String, value: String, address: String) {
        self.n = n
        self.asset = asset
        self.value = value
        self.address = address
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let n: Int = try container.decode(Int.self, forKey: .n)
        let asset: String = try container.decode(String.self, forKey: .asset)
        let value: String = try container.decode(String.self, forKey: .value)
        let address: String = try container.decode(String.self, forKey: .address)
        self.init(n: n, asset: asset, value: value, address: address)
    }
}

