//
//  ActivityIndicator.swift
//  Helper
//
//  Created by EJun on 2018. 5. 14..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: NSObject {
    
    var myActivityIndicator:UIActivityIndicatorView!
    
    func StartActivityIndicator(obj:UIViewController) -> UIActivityIndicatorView {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRect(x: 100, y: 100, width: 100, height: 100)) as UIActivityIndicatorView
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.myActivityIndicator.center = obj.view.center;
        
        obj.view.addSubview(myActivityIndicator);
        
        self.myActivityIndicator.startAnimating();
        return self.myActivityIndicator;
    }
    
    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void {
        UIApplication.shared.endIgnoringInteractionEvents()
        
        indicator.removeFromSuperview();
    }
}
