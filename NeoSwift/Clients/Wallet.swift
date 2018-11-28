//
//  Wallet.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 22/11/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Wallet: NSObject, Codable {
    @objc public var name: String?
    @objc public var version = "1.0"
    @objc public var scrypt = Scrypt()
    @objc public var accounts = [Account]()
    @objc public var extra: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case version
        case scrypt
        case accounts
        case extra
    }
    
    public override init() {
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(extra, forKey: .extra)
        try container.encode(accounts, forKey: .accounts)
        try container.encode(scrypt, forKey: .scrypt)
        try container.encode(version, forKey: .version)
        try container.encode(name, forKey: .name)
    }
    
    public init(name: String?, version: String, scrypt: Scrypt,
                accounts: [Account], extra: String?) {
        self.name = name
        self.version = version
        self.scrypt = scrypt
        self.accounts = accounts
        self.extra = extra
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String? = try container.decode(String?.self, forKey: .name)
        let version: String = try container.decode(String.self, forKey: .version)
        let scrypt: Scrypt = try container.decode(Scrypt.self, forKey: .scrypt)
        let accounts: [Account] = try container.decode([Account].self, forKey: .accounts)
        let extra: String? = try container.decode(String?.self, forKey: .extra)
        self.init(name: name, version: version, scrypt: scrypt, accounts: accounts, extra: extra)
    }
    
    @objc static func importKeystoreJson(_ json: String, passphrase: String) -> Wallet? {
        do {
            let data = json.data(using: .utf8)
            let wallet = try JSONDecoder().decode(Wallet.self, from: data!)
            
            for account in wallet.accounts {
                account.decrypt(passphrase: passphrase, scryptParam: wallet.scrypt)
            }
            
            return wallet
        }
        catch {
            return nil
        }
    }
}
