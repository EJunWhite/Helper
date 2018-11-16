//
//  ImageUtil.swift
//  Helper
//
//  Created by EJun on 2018. 5. 23..
//  Copyright © 2018년 EJun. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    static func imageOrientation(_ src:UIImage) -> UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
            case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
                transform = transform.translatedBy(x: src.size.width, y: src.size.height)
                transform = transform.rotated(by: CGFloat(M_PI))
                break
            case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
                transform = transform.translatedBy(x: src.size.width, y: 0)
                transform = transform.rotated(by: CGFloat(M_PI_2))
                break
            case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
                transform = transform.translatedBy(x: 0, y: src.size.height)
                transform = transform.rotated(by: CGFloat(-M_PI_2))
                break
            case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
                break
        }
        
        switch src.imageOrientation {
            case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
                transform.translatedBy(x: src.size.width, y: 0)
                transform.scaledBy(x: -1, y: 1)
                break
            case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
                transform.translatedBy(x: src.size.height, y: 0)
                transform.scaledBy(x: -1, y: 1)
            case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
                break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
            case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
                ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
                break
            default:
                ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
                break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
}
