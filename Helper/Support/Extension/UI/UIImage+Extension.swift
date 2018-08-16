//
//  UIFont.swift
//
//  Created by EJun on 2017. 3. 29..
//  Copyright © 2017년 EJun. All rights reserved.
//
import UIKit

extension UIImage {
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
    
    
    /// Hex Color values
    /// 
    /// HOW TO USE :uicolorFromHex(0xffffff)
    /// - Parameter rgbValue: 0xffffff
    /// - Returns: UIColor
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func image(withRotation radians: CGFloat) -> UIImage {
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        
        drawRect.size = self.size
        
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        
        var tf = CGAffineTransform.identity
        
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        
        let resultImage = UIImage(cgImage: rotatedImage)
        
        return resultImage
    }
}
