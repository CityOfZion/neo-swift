//
//  Vin.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct ValueIn: Codable {
    public var transactionID: String
    public var valueOut: Int
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "txid"
        case valueOut = "vout"
    }
    
    public init(transactionID: String, valueOut: Int) {
        self.transactionID = transactionID
        self.valueOut = valueOut
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let transactionID: String = try container.decode(String.self, forKey: .transactionID)
        let valueOut: Int = try container.decode(Int.self, forKey: .valueOut)
        self.init(transactionID: transactionID, valueOut: valueOut)
    }
}
