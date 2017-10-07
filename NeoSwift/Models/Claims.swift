//
//  Claims.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 9/9/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Claims: Codable {
    var address: String
    var claims: [Claim]
    var net: String
    var totalClaim: UInt64
    var totalUnspentClaim: Int
    
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case claims = "claims"
        case net = "net"
        case totalClaim = "total_claim"
        case totalUnspentClaim = "total_unspent_claim"
    }
    
    public init(address: String, claims: [Claim], net: String, totalClaim: UInt64, totalUnspentClaim: Int) {
        self.address = address
        self.claims = claims
        self.net = net
        self.totalClaim = totalClaim
        self.totalUnspentClaim = totalUnspentClaim
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address: String = try container.decode(String.self, forKey: .address)
        let claims: [Claim] = try container.decode([Claim].self, forKey: .claims)
        let net: String = try container.decode(String.self, forKey: .net)
        let totalClaim = try container.decode(UInt64.self, forKey: .totalClaim)
        let totalUnspentClaim = try container.decode(Int.self, forKey: .totalUnspentClaim)
        self.init(address: address, claims: claims, net: net, totalClaim: totalClaim, totalUnspentClaim: totalUnspentClaim)
    }
}

