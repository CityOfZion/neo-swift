//
//  Script.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 8/19/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation

public struct Script: Codable {
    public var invocation: String
    public var verification: String
    
    enum CodingKeys: String, CodingKey {
        case invocation = "invocation"
        case verification = "verification"
    }
    
    public init(invocation: String, verification: String) {
        self.invocation = invocation
        self.verification = verification
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let invocation: String = try container.decode(String.self, forKey: .invocation)
        let verification: String = try container.decode(String.self, forKey: .verification)
        self.init(invocation: invocation, verification: verification)
    }
}
