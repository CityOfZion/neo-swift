//
//  ContractParam.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import UIKit

class ContractParam: NSObject {
    private(set) public var type: ContractParamType
    private(set) public var value: Any
    
    static func likeContractParam(_ map: [String: Any]?) -> ContractParam? {
        guard let mapNotNull = map else {
            return nil
        }
        
        guard let typeName = mapNotNull["type"] as? String else {
            return nil
        }
        
        guard let valueNotNull = mapNotNull["value"] else {
            return nil
        }
        
        if typeName.caseInsensitiveCompare("Signature") == .orderedSame {
            return ContractParam(.Signature, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Boolean") == .orderedSame {
            return ContractParam(.Boolean, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Integer") == .orderedSame {
            return ContractParam(.Integer, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Hash160") == .orderedSame {
            return ContractParam(.Hash160, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Hash256") == .orderedSame {
            return ContractParam(.Hash256, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("ByteArray") == .orderedSame {
            return ContractParam(.ByteArray, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("PublicKey") == .orderedSame {
            return ContractParam(.PublicKey, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("String") == .orderedSame {
            return ContractParam(.String, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Array") == .orderedSame {
            return ContractParam(.Array, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("InteropInterface") == .orderedSame {
            return ContractParam(.InteropInterface, value: valueNotNull)
        }
        if typeName.caseInsensitiveCompare("Void") == .orderedSame {
            return ContractParam(.Void, value: valueNotNull)
        }
        return nil
    }
    
    init(_ type: ContractParamType, value: Any) {
        self.type = type
        self.value = value
    }
}
