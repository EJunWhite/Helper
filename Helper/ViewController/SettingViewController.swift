//
//  SettingViewController.swift
//  Helper
//
//  Created by Jun on 2018. 5. 15..
//  Copyright © 2018년 EJun. All rights reserved.
//
import Foundation
import UIKit
import PasscodeLock

class SettingViewController: SuperViewController {
    @IBOutlet weak var pinSwitch: UISwitch!
    @IBOutlet weak var changeBtn: UIButton!
    
    var configuration: PasscodeLockConfigurationType
    
    init(configuration: PasscodeLockConfigurationType) {
        
        self.configuration = configuration
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let repository = UserDefaultsPINRepository()
        configuration = PINConfiguration(repository: repository)
        
        super.init(coder: aDecoder)
    }
    
    @IBAction func switchAction(_ sender: Any) {
        let passcodeVC: PasscodeLockViewController
        
        if pinSwitch.isOn {
            print("true:::::::::")
            passcodeVC = PasscodeLockViewController(state: .setPasscode, configuration: configuration)
        } else {
            print("false:::::::::")
            passcodeVC = PasscodeLockViewController(state: .removePasscode, configuration: configuration)
            
            passcodeVC.successCallback = { lock in
                lock.repository.deletePasscode()

                // lock.configuration is not same to self.configuration
                let hasPasscode = lock.repository.hasPasscode
                
                self.pinSwitch.isOn = hasPasscode
                self.changeBtn.isEnabled = hasPasscode
                
                // SYNC from library to here
                self.configuration = lock.configuration
            }
            
        }
        present(passcodeVC, animated: true, completion: nil)
    }
    
    @IBAction func changePIN(_ sender: Any) {
        let hasPasscode = configuration.repository.hasPasscode

        if hasPasscode {
            let repo = UserDefaultsPINRepository()
            let config = PINConfiguration(repository: repo)
            let passcodeLock = PasscodeLockViewController(state: .changePasscode, configuration: config)
            
            present(passcodeLock, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func updatePasscodeView() {
        let repo = UserDefaultsPINRepository()
        let config = PINConfiguration(repository: repo)

        let hasPasscode = configuration.repository.hasPasscode
        
        debugPrint("hasPasscode ::: \(config.repository.hasPasscode)")
        
        pinSwitch.isOn = hasPasscode
        changeBtn.isEnabled = hasPasscode
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updatePasscodeView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
