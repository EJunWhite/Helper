//
//  StringUtil.swift
//  Helper
//
//  Created by smart macbook on 2018. 5. 19..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation

class StringUtil {
    /// separate and return result for first or last string
    ///
    /// - Parameters:
    ///   - str: <#str description#>
    ///   - firtsComponent: <#firtsComponent description#>
    /// - Returns: <#return value description#>
    static func components(str: String, separateBy: String, firstComponent: Bool) -> String {
        let strArray = str.components(separatedBy: separateBy)
        let count = strArray.count
        
        if firstComponent { return strArray[0] }
        else { return strArray[count - 1] }
    }
}
