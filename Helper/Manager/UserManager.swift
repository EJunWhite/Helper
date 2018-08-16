//
//  UserManager.swift
//  Helper
//
//  Created by EJun on 2018. 5. 15..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation

class UserManager {
    static let sharedInstance = UserManager()
    
    /// First Login
    ///
    /// - Returns: Bool
    func getFirstLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: UserManager.FIRST_LOGIN)
    }
    
    func setFirstLogin(enable: Bool) {
        UserDefaults.standard.setValue(enable, forKey: UserManager.FIRST_LOGIN)
    }
    
    /// Login
    ///
    /// - Returns: Bool
    func getLogin() -> Bool {
        return UserDefaults.standard.bool(forKey: UserManager.IS_LOGIN)
    }
    
    func setLogin(enable: Bool) {
        UserDefaults.standard.setValue(enable, forKey: UserManager.IS_LOGIN)
    }
    
    /// Double Security
    ///
    /// - Returns: Bool
    func getDoubleSecurity() -> Bool {
        return UserDefaults.standard.bool(forKey: UserManager.DOUBLE_SECURITY)
    }
    
    func setDoubleSecurity(enable: Bool) {
        UserDefaults.standard.setValue(enable, forKey: UserManager.DOUBLE_SECURITY)
    }
}

// MARK: UserManager
extension UserManager {
    static let IS_LOGIN = "IS_LOGIN"
    static let FIRST_LOGIN = "FIRST_LOGIN"
    static let DOUBLE_SECURITY = "DOUBLE_SECURITY"
}
