//
//  PINConfiguration.swift
//  Helper
//
//  Created by Jun on 2018. 5. 17..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import PasscodeLock

struct PINConfiguration: PasscodeLockConfigurationType {
    
    var repository: PasscodeRepositoryType
    let passcodeLength = 4
    var isTouchIDAllowed = true // TouchIDAllow
    let shouldRequestTouchIDImmediately = true
    let maximumInccorectPasscodeAttempts = -1
    
    init(repository: PasscodeRepositoryType) {
        
        self.repository = repository
    }
    
    init() {
        self.repository = UserDefaultsPINRepository()
    }
}
