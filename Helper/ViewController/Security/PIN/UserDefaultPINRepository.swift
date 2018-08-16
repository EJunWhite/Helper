//
//  UserDefaultsPINRepository.swift
//  Helper
//
//  Created by Jun on 2018. 5. 17..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import PasscodeLock

class UserDefaultsPINRepository: PasscodeRepositoryType {
    let passcodeKey = "passcode.lock.passcode"
    
    lazy var defaults: UserDefaults = {
        return UserDefaults.standard
    }()
    
    var hasPasscode: Bool {
        
        if passcode != nil {
            return true
        }
        
        return false
    }
    
    var passcode: [String]? {
        
        return defaults.value(forKey: passcodeKey) as? [String] ?? nil
    }
    
    func savePasscode(_ passcode: [String]) {
        
        defaults.set(passcode, forKey: passcodeKey)
        defaults.synchronize()
    }
    
    func deletePasscode() {
        
        defaults.removeObject(forKey: passcodeKey)
        defaults.synchronize()
    }
}
