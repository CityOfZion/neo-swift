//
//  Asset.swift
//  O3
//
//  Created by Apisit Toompakdee on 8/7/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Asset: NSObject, Codable {
    
    @objc let name: String
    @objc let symbol: String
    @objc let logoURL: String
    @objc let url: String?
    @objc let webURL: String?
    @objc let tokenHash: String?
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
