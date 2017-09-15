//
//  SHA256Tests.swift
//  NeoSwift
//
//  Created by Luís Silva on 13/09/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import XCTest

class SHA256Tests: XCTestCase {
    func testEncoding() {
        XCTAssert("".sha256?.fullHexString == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        XCTAssert("NEO".sha256?.fullHexString == "1a259dba256600620c6c91094f3a300b30f0cbaecee19c6114deffd3288957d7")
        XCTAssert("Smart Economy".sha256?.fullHexString == "6c4cb281896c7779f4e2800471638026d52178b2556a0a3fbc3673368ba97385")
    }
}
