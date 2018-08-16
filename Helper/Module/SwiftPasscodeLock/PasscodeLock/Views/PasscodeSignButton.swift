//
//  PasscodeSignButton.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
open class PasscodeSignButton: UIButton {
    
    @IBInspectable
    open var passcodeSign: String = "1"
    
    @IBInspectable
    open var borderColor: UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }

    
    @IBInspectable
    open var highlightBackgroundColor: UIColor = UIColor.clear {
        didSet {

            setupView()
        }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
        setupActions()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupActions()
    }

    fileprivate var defaultBackgroundColor = UIColor.clear
    
    fileprivate func setupView() {
        
        layer.borderWidth = 1
        //self.layer.cornerRadius = self.frame.width/2
        layer.borderColor = borderColor.cgColor
        
        if let backgroundColor = backgroundColor {
            
            defaultBackgroundColor = backgroundColor
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = rect.width/2
    }


    
    fileprivate func setupActions() {
        
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc func handleTouchDown() {
        
        animateBackgroundColor(highlightBackgroundColor)
    }
    
    @objc func handleTouchUp() {
        
        animateBackgroundColor(defaultBackgroundColor)
    }
    
    fileprivate func animateBackgroundColor(_ color: UIColor) {
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                
                self.layer.backgroundColor = color.cgColor
            },
            completion: nil
        )
    }
}
