//
//  ContractParam.swift
//  NeoSwift
//
//  Created by Ricardo Kobayashi on 10/10/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import Foundation

@objc enum ContractParamType: UInt8 {
    case Signature = 0x00,
    Boolean = 0x01,
    Integer = 0x02,
    Hash160 = 0x03,
    Hash256 = 0x04,
    ByteArray = 0x05,
    PublicKey = 0x06,
    String = 0x07,
    Array = 0x10,
    InteropInterface = 0xf0,
    Void = 0xff
}
