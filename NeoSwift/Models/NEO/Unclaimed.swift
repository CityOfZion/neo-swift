//
//  Unclaimed.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 05/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc public class Unclaimed: NSObject, Codable {
    @objc public var claimable: [Claimable]
    @objc public var unclaimed: Double
    @objc public var address: String
    
    enum CodingKeys: String, CodingKey {
        case claimable
        case unclaimed
        case address
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var claimable = [Claimable] ()
        if container.contains(.claimable) {
            claimable = try container.decode([Claimable].self, forKey: .claimable)
        }
        let unclaimed: Double = try container.decode(Double.self, forKey: .unclaimed)
        let address: String = try container.decode(String.self, forKey: .address)
        self.init(claimable: claimable, unclaimed: unclaimed, address: address)
    }
    
    public init(claimable: [Claimable], unclaimed: Double, address: String) {
        self.claimable = claimable
        self.unclaimed = unclaimed
        self.address = address
    }

}
