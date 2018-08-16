//
//  UIFont.swift
//
//  Created by EJun on 2017. 3. 29..
//  Copyright © 2017년 EJun. All rights reserved.
//
import UIKit

extension UIFont {
    
    static func noc_mediumSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        var font: UIFont
        if #available(iOS 8.2, *) {
            font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        } else {
            font = UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
        }
        return font
    }
    
}
