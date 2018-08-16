//
//  UIViewController.swift
//
//  Created by EJun on 2017. 3. 29..
//  Copyright © 2017년 EJun. All rights reserved.
//
import UIKit
import Foundation

extension UIViewController {
    func setTitle(title: String) {
        let navBar:UINavigationBar = UINavigationBar()
        navBar.topItem?.title = title
    }
    
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertForAppDelegate(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        present(viewControllerToPresent, animated: flag, completion: nil)
    }
   
}
