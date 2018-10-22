//
//  Asset.swift
//  O3
//
//  Created by Apisit Toompakdee on 8/7/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

public struct Asset: Codable {
    
    let name: String
    let symbol: String
    let logoURL: String
    let url: String?
    let webURL: String?
    let tokenHash: String?
    let decimal: Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case decimal = "decimal"
        case tokenHash = "tokenHash"
        case logoURL = "logoURL"
        case webURL = "webURL"
        case url = "url" //this is a url to go to token detail screen
    }
}
