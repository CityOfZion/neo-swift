//
//  validator.swift
//  NeoSwift
//
//  Created by Andrei Terentiev on 2/21/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import Neoutils

public class NEOValidator {
    public static func validateNEOAddress(_ address: String) -> Bool {
        return NeoutilsValidateNEOAddress(address)
    }
}
