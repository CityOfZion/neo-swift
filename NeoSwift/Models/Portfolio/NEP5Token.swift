//
//  NEP5Token.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/29/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

@objc public class NEP5Token: NSObject, Codable {
    @objc public var name: String
    @objc public var symbol: String
    @objc public var decimals: Int
    @objc public var totalSupply: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case decimals = "decimals"
        case totalSupply = "totalSupply"
    }
    
    @objc public init(name: String, symbol: String, decimals: Int, totalSupply: Int) {
        self.name = name
        self.symbol = symbol
        self.decimals = decimals
        self.totalSupply = totalSupply
    }
    
    @objc public init?(from vmStack: [StackEntry]) {
        let nameEntry = vmStack[0]
        let symbolEntry = vmStack[1]
        let decimalsEntry = vmStack[2]
        let totalSupplyEntry = vmStack[3]
        guard let name = String(data: (nameEntry.hexDataValue?.dataWithHexString())!, encoding: .utf8),
            let symbol = String(data: (symbolEntry.hexDataValue?.dataWithHexString())!, encoding: .utf8),
            let totalSupplyData = totalSupplyEntry.hexDataValue else {
                return nil
        }
        let totalSupply = UInt64(littleEndian: totalSupplyData.dataWithHexString().withUnsafeBytes { $0.pointee })
        self.name = name
        self.symbol = symbol
        self.decimals = decimalsEntry.intValue
        self.totalSupply = Int(totalSupply / 100000000)
    }
}
