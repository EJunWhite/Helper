//
//  CoreLogger.swift
//  Helper
//
//  Created by EJun on 2018. 8. 14..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import XCGLogger

let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")

let log: XCGLogger = {
    let log = XCGLogger(identifier: "Helper", includeDefaultDestinations: false)
    
    #if DEBUG
    systemDestination.outputLevel = .debug
    #else
    systemDestination.outputLevel = .severe
    #endif
    
    // Optionally set some configuration options
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = false
    systemDestination.showLevel = false
    systemDestination.showFileName =  true
    systemDestination.showLineNumber = false
    systemDestination.showDate = false
    
    log.add(destination: systemDestination)
    log.logAppDetails()
    
    return log
}()
