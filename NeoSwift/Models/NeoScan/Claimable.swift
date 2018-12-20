//
//  Claimable.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Claimable: NSObject, Codable {
    @objc public var value: Double
    @objc public var unclaimed: Double
    @objc public var txid: String
    @objc public var sys_fee: Double
    @objc public var start_height: Int
    @objc public var n: Int
    @objc public var generated: Double
    @objc public var end_height: Int
    
    enum CodingKeys: String, CodingKey {
        case value
        case unclaimed
        case txid
        case sys_fee
        case start_height
        case n
        case generated
        case end_height
    }
    
    public init(value: Double, unclaimed: Double, txid: String, sys_fee: Double, start_height: Int, n: Int, generated: Double, end_height: Int) {
        self.value = value
        self.unclaimed = unclaimed
        self.txid = txid
        self.sys_fee = sys_fee
        self.start_height = start_height
        self.n = n
        self.generated = generated
        self.end_height = end_height
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value: Double = try container.decode(Double.self, forKey: .value)
        let unclaimed: Double = try container.decode(Double.self, forKey: .unclaimed)
        let txid: String = try container.decode(String.self, forKey: .txid)
        let sys_fee: Double = try container.decode(Double.self, forKey: .sys_fee)
        let start_height: Int = try container.decode(Int.self, forKey: .start_height)
        let n: Int = try container.decode(Int.self, forKey: .n)
        let generated: Double = try container.decode(Double.self, forKey: .generated)
        let end_height: Int = try container.decode(Int.self, forKey: .end_height)
        self.init(value: value, unclaimed: unclaimed, txid: txid, sys_fee: sys_fee, start_height: start_height, n: n, generated: generated, end_height: end_height)
    }
}
