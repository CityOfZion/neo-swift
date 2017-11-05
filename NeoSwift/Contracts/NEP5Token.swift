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
    
    public init?(from vmStack: [StackEntry]) {
        let nameEntry = vmStack[0]
        let symbolEntry = vmStack[1]
        let decimalsEntry = vmStack[2]
        let totalSupplyEntry = vmStack[3]
        guard let name = String(data: (nameEntry.hexDataValue?.dataWithHexString())!, encoding: .utf8),
            let symbol = String(data: (symbolEntry.hexDataValue?.dataWithHexString())!, encoding: .utf8),
            let decimals = decimalsEntry.intValue,
            let totalSupplyData = totalSupplyEntry.hexDataValue else {
                return nil
        }
        let totalSupply = UInt64(littleEndian: totalSupplyData.dataWithHexString().withUnsafeBytes { $0.pointee })
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.totalSupply = Int(totalSupply / 100000000)
    }
}
