//
//  String.swift
//
//  Created by EJun on 2017. 3. 29..
//  Copyright © 2017년 EJun. All rights reserved.
//
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    /// Check Email
    /// -_+%. 만 가능
    ///
    /// - Parameter str: String
    /// - Returns: Bool
    static func isValidEmail(str:String) -> Bool {
        print("validate emilId: \(str)")
        
        //let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let result = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
        print("result :\(result)")
        
        return result

    }
    
    /// Check 한글 and 알파벳
    ///
    /// - Parameter str: String
    /// - Returns: bool
    static func isValidKR_EN(str:String) -> Bool {
        print("isValidKR emilId: \(str)")
        
        let regEx = "^[ㄱ-힣a-zA-Z]*$"
        
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        let result = test.evaluate(with: str)
        
        return result
    }
    
    static func isPhoneNumbervalidate(value: String) -> Bool {
        let PHONEREGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONEREGEX)
        let result =  phoneTest.evaluate(with: value)
        
        print("result: \(result)")
        
        return result
    }
    
    static func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        
        print("result: \(result)")

        return result
    }
    
    static func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.characters.count <= 7 && confirmPassword.characters.count <= 7{
            return true
        }
        else{
            return false
        }
    }
    
    subscript(idx: Int) -> Character {
        guard let strIdx = index(startIndex, offsetBy: idx, limitedBy: endIndex)
            else { fatalError("String index out of bounds") }
        return self[strIdx]
    }
    
    func indexDistance(of character: Character) -> Int? {
        guard let index = characters.index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
    
    func replace(delim: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: delim, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
