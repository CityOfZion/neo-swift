//
//  Script.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 20/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

@objc public class Script: NSObject, Codable {
    @objc public var verification: String
    @objc public var invocation: String
    
    enum CodingKeys: String, CodingKey {
        case verification
        case invocation
    }
    
    public init(verification: String, invocation: String) {
        self.verification = verification
        self.invocation = invocation
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let verification: String = try container.decode(String.self, forKey: .verification)
        let invocation: String = try container.decode(String.self, forKey: .invocation)
        self.init(verification: verification, invocation: invocation)
    }

}
