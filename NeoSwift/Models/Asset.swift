//
//  Asset.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
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
    public var amount: Int64
    public var available: Int64
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
    
    public init(version: Int, id: String, type: String, names: [AssetName], amount: Int64, available: Int64, precision: Int, admin: String, issuer: String, expiration: Int, frozen: Bool){
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
		let amountString: String = try container.decode(String.self, forKey: .amount)
        let amount: Int64 = Int64(amountString) ?? 0
        let availableString: String = try container.decode(String.self, forKey: .available)
		let available: Int64 = Int64(availableString) ?? 0
        let precision: Int = try container.decode(Int.self, forKey: .precision)
        let admin: String = try container.decode(String.self, forKey: .admin)
        let issuer: String = try container.decode(String.self, forKey: .issuer)
        let expiration: Int = try container.decode(Int.self, forKey: .expiration)
        let frozen: Bool = try container.decode(Bool.self, forKey: .frozen)
        self.init(version: version, id: id, type: type, names: names, amount: amount, available: available, precision: precision, admin: admin, issuer: issuer, expiration: expiration, frozen: frozen)
    }
}

public struct Asset: Codable {
    public var id: String
    public var value: Double
    
    enum CodingKeys : String, CodingKey {
        case id = "asset"
        case value = "value"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let valueString: String = try container.decode(String.self, forKey: .value)
		let value: Double = Double(valueString) ?? 0
        self.init(id: id, value: value)
    }
    
    public init(id: String, value: Double) {
        self.id = id
        self.value = value
    }
    
}
