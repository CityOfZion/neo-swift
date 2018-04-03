//
//  Claimable.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 4/2/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

// This struct is for neo-scan get_claimable API
// https://neoscan.io/api/main_net/v1/get_claimable/AeNkbJdiMx49kBStQdDih7BzfDwyTNVRfb
public struct Claimable: Codable {
    public let unclaimed: Double
    public let claimable: [ClaimableElement]
    public let address: String
    
    enum CodingKeys: String, CodingKey {
        case unclaimed = "unclaimed"
        case claimable = "claimable"
        case address = "address"
    }
}

public struct ClaimableElement: Codable {
    public let value: Int
    public let unclaimed: Double
    public let txid: String
    public let startHeight: Int
    public let n: Int
    public let endHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case unclaimed = "unclaimed"
        case txid = "txid"
        case startHeight = "start_height"
        case n = "n"
        case endHeight = "end_height"
    }
}


