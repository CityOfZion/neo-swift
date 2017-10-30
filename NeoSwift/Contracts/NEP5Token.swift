//
//  NEP5Token.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/29/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct NEP5Token: Codable {
    public static var tokens: [String: String] = ["RPX": "ecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9"]
    
    public var name: String
    public var symbol: String
    public var decimals: Int
    public var totalSupply: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case decimals = "decimals"
        case totalSupply = "totalSupply"
    }
    
    public init(name: String, symbol: String, decimals: Int, totalSupply: Int) {
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.totalSupply = totalSupply
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decode(String.self, forKey: .name)
        let symbol: String = try container.decode(String.self, forKey: .symbol)
        let decimals: Int = try container.decode(Int.self, forKey: .decimals)
        let totalSupply: Int = try container.decode(Int.self, forKey: .totalSupply)
        self.init(name: name, symbol: symbol, decimals: decimals, totalSupply: totalSupply)
    }
}
