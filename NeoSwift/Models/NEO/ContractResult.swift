//
//  ContractResult.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 10/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

private enum StackEntryCodingKeys: String, CodingKey {
    case type = "type"
    case value = "value"
}

@objc public class StackEntry: NSObject, Codable {
    @objc public enum VMOutputType: Int, Codable {
        case byteArray,
        int,
        array
    }

    @objc public var type: VMOutputType
    @objc public var intValue: Int = 0
    @objc public var hexDataValue: String?
    @objc public var arrayValue: [StackEntry]?
    
    @objc public init(type: VMOutputType, value: Any) {
        self.type = type
        if type == .array {
            if let arrayValue = value as? [StackEntry]  {
                self.arrayValue = arrayValue
                return
            }
        }
        guard let stringValue = value as? String else {
            fatalError("Unknown output from the VM")
        }
        if type == .byteArray {
            self.hexDataValue = stringValue
        } else if type == .int {
            let int = Int(stringValue) ?? 0
            self.intValue = int
        }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StackEntryCodingKeys.self)
        let typeString: String = try container.decode(String.self, forKey: .type)
        if typeString.elementsEqual("Array") {
            let values = try container.decode([StackEntry].self, forKey: StackEntryCodingKeys.value)
            self.init(type: .byteArray, value: values)
        }
        else if typeString.elementsEqual("ByteArray") {
            let value = try container.decode(String.self, forKey: StackEntryCodingKeys.value)
            self.init(type: .byteArray, value: value as Any)
        }
        else if typeString.elementsEqual("Integer") {
            let value = try container.decode(String.self, forKey: StackEntryCodingKeys.value)
            self.init(type: .int, value: value)
        }
        else {
            fatalError()
        }
    }
}

@objc public class ContractResult: NSObject, Codable {
    @objc public var state: String //TODO: Make this enum of all possible sates
    @objc public var gasConsumed: Double
    @objc public var stack: [StackEntry]
    
    enum CodingKeys: String, CodingKey {
        case state = "state"
        case gasConsumed = "gas_consumed"
        case stack = "stack"
    }
    
    @objc public init(state: String, gasConsumed: Double, stack: [StackEntry]) {
        self.state = state
        self.gasConsumed = gasConsumed
        self.stack = stack
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let state: String = try container.decode(String.self, forKey: .state)
        let gasConsumed: String = try container.decode(String.self, forKey: .gasConsumed)
        let gasConsumedDouble = Double(gasConsumed)! // this prolly shouldnt be a string in the response from NEO
        let stack: [StackEntry] = try container.decode([StackEntry].self, forKey: .stack)
        self.init(state: state, gasConsumed: gasConsumedDouble, stack: stack)
    }
}
