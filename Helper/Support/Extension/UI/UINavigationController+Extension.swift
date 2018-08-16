//
//  UINavigationController.swift
//
//  Created by EJun on 2017. 5. 26..
//  Copyright © 2017년 EJun. All rights reserved.
//
import UIKit

extension UINavigationController {
    /// Change : Status bar color
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        let name: String = String(describing: type(of: self))
        
        /* StatusBar의 color은 UINavigationController에서 변경 한다. 강제적으로 UIImagePickerController 의 명칭을 비교하여 white와black로 표시함. */
//        if name == "UIImagePickerController" {
//            return .default
//        } else {
//            return .lightContent
//        }
        
        return .lightContent
    }
}
