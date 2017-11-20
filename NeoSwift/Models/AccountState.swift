//
//  AccountState.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 9/13/17.
//  Copyright © 2017 drei. All rights reserved.
//

public struct AccountState: Codable {
    public var version: Int
    public var scriptHash: String
    public var frozen: Bool
    //var votes: it's there in JSON response but I don't know what type is it.
    public var balances: [Asset]
    
    enum CodingKeys : String, CodingKey {
        case version = "version"
        case scriptHash = "script_hash"
        case frozen = "frozen"
        case balances = "balances"
    }
    
    public init(version: Int, scriptHash: String, frozen: Bool, balances: [Asset]) {
        self.version = version
        self.scriptHash = scriptHash
        self.frozen = frozen
        self.balances = balances
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let version: Int = try container.decode(Int.self, forKey: .version)
        let scriptHash: String = try container.decode(String.self, forKey: .scriptHash)
        let frozen: Bool = try container.decode(Bool.self, forKey: .frozen)
        let balances: [Asset] = try container.decode([Asset].self, forKey: .balances)
        self.init(version: version, scriptHash: scriptHash, frozen: frozen, balances: balances)
    }
    
}
