//
//  Claimed.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Claimed: NSObject, Codable {
    @objc public var txids: [String]
    
    enum CodingKeys: String, CodingKey {
        case txids
    }
    
    public init(txids: [String]) {
        self.txids = txids
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let txids: [String] = try container.decode([String].self, forKey: .txids)
        self.init(txids: txids)
    }
}

@objc public class ClaimedResponse: NSObject, Codable {
    @objc public var claimed: [Claimed]
    @objc public var address: String
    
    enum CodingKeys: String, CodingKey {
        case claimed
        case address
    }
    
    public init(claimed: [Claimed], address: String) {
        self.claimed = claimed
        self.address = address
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let claimed: [Claimed] = try container.decode([Claimed].self, forKey: .claimed)
        let address: String = try container.decode(String.self, forKey: .address)
        self.init(claimed: claimed, address: address)
    }
}

