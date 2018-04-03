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
struct Claimable: Codable {
    let unclaimed: Double
    let claimable: [ClaimableElement]
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case unclaimed = "unclaimed"
        case claimable = "claimable"
        case address = "address"
    }
}

struct ClaimableElement: Codable {
    let value: Int
    let unclaimed: Double
    let txid: String
    let startHeight: Int
    let n: Int
    let endHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case unclaimed = "unclaimed"
        case txid = "txid"
        case startHeight = "start_height"
        case n = "n"
        case endHeight = "end_height"
    }
}


