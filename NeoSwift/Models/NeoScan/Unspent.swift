//
//  Unspent.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Unspent: NSObject, Codable {
    @objc public var value: Double
    @objc public var txid: String
    @objc public var n: Int
    
    enum CodingKeys: String, CodingKey {
        case value
        case txid
        case n
    }
    
    public init(value: Double, txid: String, n: Int) {
        self.value = value
        self.txid = txid
        self.n = n
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value: Double = try container.decode(Double.self, forKey: .value)
        let txid: String = try container.decode(String.self, forKey: .txid)
        let n: Int = try container.decode(Int.self, forKey: .n)
        self.init(value: value, txid: txid, n: n)
    }
}
