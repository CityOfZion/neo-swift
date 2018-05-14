//
//  Claims.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 9/9/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

typealias Claim = Claimable.Claim
public struct Claimable: Codable {
    public var gas: Decimal
    public var claims: [Claim]
    
    enum CodingKeys: String, CodingKey {
        case gas = "gas"
        case claims = "claims"
    }
    
    public init(gas: Decimal, claims: [Claim]) {
        self.gas = gas
        self.claims = claims
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gasValueString: String = try container.decode(String.self, forKey: .gas)
        let format = NumberFormatter()
        format.minimumFractionDigits = 0
        format.maximumFractionDigits = 8
        let value = format.number(from: gasValueString)?.decimalValue
        let gasValue = value!
        let claims: [Claim] = try container.decode([Claim].self, forKey: .claims)
        self.init(gas: gasValue, claims: claims)
    }
    
    public struct Claim: Codable {
        public var asset: String
        public var index: UInt16
        public var txid: String
        public var value: Decimal
        public var createdAtBlock: Int
    
        enum CodingKeys: String, CodingKey {
            case asset
            case index
            case txid
            case value
            case createdAtBlock
        }
        
        public init(asset: String, index: UInt16, txid: String, value: Decimal, createdAtBlock: Int) {
            self.asset = asset
            self.index = index
            self.txid = txid
            self.value = value
            self.createdAtBlock = createdAtBlock
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let asset: String = try container.decode(String.self, forKey: .asset)
            let index: UInt16 = try container.decode(UInt16.self, forKey: .index)
            var txid: String = try container.decode(String.self, forKey: .txid)
            txid = String(txid.dropFirst(2))
            let valueString: String = try container.decode(String.self, forKey: .value)
            let format = NumberFormatter()
            format.minimumFractionDigits = 0
            format.maximumFractionDigits = 8
            let value = format.number(from: valueString)?.decimalValue
            let createdAtBlock: Int = try container.decode(Int.self, forKey: .createdAtBlock)
            self.init(asset: asset, index: index, txid: txid, value: value!, createdAtBlock: createdAtBlock)
            
        }
    
    }
}

