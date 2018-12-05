//
//  Unclaimed.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 05/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc public class Unclaimed: NSObject, Codable {
    @objc public var unclaimed: Double
    @objc public var address: String
    
    enum CodingKeys: String, CodingKey {
        case unclaimed = "unclaimed"
        case address = "address"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let unclaimed: Double = try container.decode(Double.self, forKey: .unclaimed)
        let address: String = try container.decode(String.self, forKey: .address)
        self.init(unclaimed: unclaimed, address: address)
    }
    
    public init(unclaimed: Double, address: String) {
        self.unclaimed = unclaimed
        self.address = address
    }

}
