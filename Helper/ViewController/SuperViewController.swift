//
//  SuperUIViewController.swift
//  Helper
//
//  Created by EJun on 2018. 5. 14..
//  Copyright © 2018년 EJun. All rights reserved.
//
import UIKit

class SuperViewController: UIViewController {
    public var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Show Activity Indicator
    func showIndicator() {
        self.activityIndicator = ActivityIndicator().StartActivityIndicator(obj: self)
        self.activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    // MARK: Show Activity Indicator
    func showIndicator(obj: UIViewController) {
        self.activityIndicator = ActivityIndicator().StartActivityIndicator(obj: obj.self)
        self.activityIndicator.activityIndicatorViewStyle = .gray
    }
    
    // MARK: Hide Activity Indicator
    func hideIndicator() {
        if self.activityIndicator != nil {
            ActivityIndicator().StopActivityIndicator(obj: ViewController(),indicator: self.activityIndicator)
        }
    }
    
    // MARK: Alert
    func showAlertAboutTryToLater(error: Error?) {
        self.showAlert(title: "알림", msg: "잠시후 다시 시도해주세요")
    }
    
    func showAlert(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.modalPresentationStyle = .overCurrentContext
        alertController.modalTransitionStyle = .crossDissolve
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: GetViewController
    func getViewController<T>(_ viewController: T, _ isTransitonStyle: Bool) -> NSObject {
        let vcName = String(describing: viewController)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: vcName)
        if isTransitonStyle {
            vc?.modalPresentationStyle = .overCurrentContext
            vc?.modalTransitionStyle = .crossDissolve
        }
        
        return vc!
    }
    
    func getViewControllerInStoryBoard(_ identifier: String, _ isTransitonStyle: Bool) -> NSObject {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        if isTransitonStyle {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
        }
        
        return vc as NSObject
    }
    
    func getViewControllerInStoryBoard<T>(_ viewController: T, _ isTransitonStyle: Bool) -> NSObject {
        let identifier = String(describing: viewController)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        
        if isTransitonStyle {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
        }
        
        return vc as NSObject
    }
    
}
