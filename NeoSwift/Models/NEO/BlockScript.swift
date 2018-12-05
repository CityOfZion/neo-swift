//
//  BlockScript.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 05/12/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc public class BlockScript: NSObject, Codable {
    @objc public var verification: String
    @objc public var invocation: String
    @objc public var identifier: String
    
    enum CodingKeys: String, CodingKey {
        case verification = "verification"
        case invocation = "invocation"
        case identifier = "id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let verification: String = try container.decode(String.self, forKey: .verification)
        let invocation: String = try container.decode(String.self, forKey: .invocation)
        let identifier: String = try container.decode(String.self, forKey: .identifier)
        self.init(verification: verification, invocation: invocation, identifier: identifier)
    }
    
    public init(verification: String, invocation: String, identifier: String) {
        self.verification = verification
        self.invocation = invocation
        self.identifier = identifier
    }

}
