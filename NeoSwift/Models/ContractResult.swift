//
//  ContractResult.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct StackEntry: Decodable {
    public enum VMOutputType: String {
        case byteArray = "ByteArray",
        int = "Integer"
        
    }
    public var type: VMOutputType
    public var intValue: Int?
    public var hexDataValue: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case value = "value"
    }
    
    public init(type: VMOutputType, value: Any) {
        self.type = type
        guard let stringValue = value as? String else {
            fatalError("Unknown output from the VM")
        }
        if type == .byteArray {
            self.hexDataValue = stringValue
        } else {
            let int = Int(stringValue) ?? 0
            self.intValue = int
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString: String = try container.decode(String.self, forKey: .type)
        let value: Any = try container.decode(String.self, forKey: .value)
        self.init(type: VMOutputType(rawValue: typeString)!, value: value)
    }
}

public struct ContractResult: Decodable {
    public var state: String //TODO: Make this enum of all possible sates
    public var gasConsumed: Double
    public var stack: [StackEntry]
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case gasConsumed = "gas_consumed"
        case stack = "stack"
    }
    
    public init(state: String, gasConsumed: Double, stack: [StackEntry]) {
        self.state = state
        self.gasConsumed = gasConsumed
        self.stack = stack
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let state: String = try container.decode(String.self, forKey: .state)
        let gasConsumed: String = try container.decode(String.self, forKey: .gasConsumed)
        let gasConsumedDouble = Double(gasConsumed)! // this prolly shouldnt be a string in the response from NEO
        let stack: [StackEntry] = try container.decode([StackEntry].self, forKey: .stack)
        self.init(state: state, gasConsumed: gasConsumedDouble, stack: stack)
    }
}
