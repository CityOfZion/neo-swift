//
//  Asset.swift
//  O3
//
//  Created by Apisit Toompakdee on 8/7/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

public struct AssetName: Codable {
    
    public var languageCode: String
    public var name: String
    
    enum CodingKeys : String, CodingKey {
        case languageCode = "lang"
        case name = "name"
    }
    
    public init(languageCode: String, name: String) {
        self.languageCode = languageCode
        self.name = name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let languageCode: String = try container.decode(String.self, forKey: .languageCode)
        let name: String = try container.decode(String.self, forKey: .name)
        self.init(languageCode: languageCode, name: name)
    }
}

public struct AssetState: Codable {
    
    public var version: Int
    public var id: String
    public var type: String
    public var names: [AssetName]
    public var amount: String
    public var available: String
    public var precision: Int
    public var admin: String
    public var issuer: String
    public var expiration: Int
    public var frozen: Bool
    
    enum CodingKeys : String, CodingKey {
        case version = "version"
        case id = "id"
        case type = "type"
        case names = "name"
        case amount = "amount"
        case available = "available"
        case precision = "precision"
        case admin = "admin"
        case issuer = "issuer"
        case expiration = "expiration"
        case frozen = "frozen"
    }
    
    public init(version: Int, id: String, type: String, names: [AssetName], amount: String, available: String, precision: Int, admin: String, issuer: String, expiration: Int, frozen: Bool){
        self.version = version
        self.id = id
        self.type = type
        self.names = names
        self.amount = amount
        self.available = available
        self.precision = precision
        self.admin = admin
        self.issuer = issuer
        self.expiration = expiration
        self.frozen = frozen
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version: Int = try container.decode(Int.self, forKey: .version)
        let id: String = try container.decode(String.self, forKey: .id)
        let type: String = try container.decode(String.self, forKey: .type)
        let names: [AssetName] = try container.decode([AssetName].self, forKey: .names)
        let amount: String = try container.decode(String.self, forKey: .amount)
        let available: String = try container.decode(String.self, forKey: .available)
        let precision: Int = try container.decode(Int.self, forKey: .precision)
        let admin: String = try container.decode(String.self, forKey: .admin)
        let issuer: String = try container.decode(String.self, forKey: .issuer)
        let expiration: Int = try container.decode(Int.self, forKey: .expiration)
        let frozen: Bool = try container.decode(Bool.self, forKey: .frozen)
        self.init(version: version, id: id, type: type, names: names, amount: amount, available: available, precision: precision, admin: admin, issuer: issuer, expiration: expiration, frozen: frozen)
    }
}

public struct Asset: Codable {
    
    let name: String
    let symbol: String
    let logoURL: String
    let url: String?
    let logoURLDark: String?
    let logoSVG: String?
    let webURL: String?
    let tokenHash: String?
    let decimal: Int? = 0
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case decimal = "decimal"
        case tokenHash = "tokenHash"
        case logoURL = "logoURL"
        case logoURLDark = "logoURLDark"
        case logoSVG = "logoSVG"
        case webURL = "webURL"
        case url = "url" //this is a url to go to token detail screen
    }
}

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
