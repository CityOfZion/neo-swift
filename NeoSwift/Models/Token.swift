//
//  Token.swift
//  NeoSwift
//
//  Created by Apisit Toompakdee on 12/18/17.
//  Copyright © 2017 O3 Labs. All rights reserved.
//

import UIKit

public struct TokenBalance {
    let amount: Double
    public init(amount: Double) {
        self.amount = amount
    }
}

public struct Stack : Codable {
    let type : String?
    let value : String?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case value = "value"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
    
}

public struct BalanceOfResult : Codable {
    let state : String?
    let gasConsumed : String?
    let stack : [Stack]?
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case gasConsumed = "gas_consumed"
        case stack = "stack"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        gasConsumed = try values.decodeIfPresent(String.self, forKey: .gasConsumed)
        stack = try values.decodeIfPresent([Stack].self, forKey: .stack)
    }
    

}
