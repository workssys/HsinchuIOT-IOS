//
//  StatusIconView.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/17/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class StatusIconView: UIView {
    
    var shadowGradientStartColor: UIColor = UIColor.blackColor()
    var shadowGradientEndColor: UIColor = UIColor.whiteColor()
    var fillColor: UIColor = UIColor.greenColor()
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        
        let radius = self.frame.width / 2
        
        //first draw shadow
        let rgb = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradientCreateWithColors(rgb, [shadowGradientStartColor.CGColor, shadowGradientEndColor.CGColor], [1.0, 0.0])
        
        CGContextAddArc(context, radius, radius, radius, 0, (CGFloat)(2.0 * M_PI), 0)
        CGContextClosePath(context)
        CGContextClip(context)
        
        CGContextDrawLinearGradient(context,
            gradient,
            CGPointMake(0, 0),
            CGPointMake(0, self.frame.height),
            CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        let radius2 = radius - 2
        let gradient2 = CGGradientCreateWithColors(rgb, [fillColor.CGColor, UIColor.whiteColor().CGColor], [0.0, 1.0])
        
        CGContextAddArc(context, radius, radius, radius2, 0, (CGFloat)(2.0 * M_PI), 0)
        CGContextClosePath(context)
        CGContextClip(context)
        
        CGContextDrawRadialGradient(context, gradient2, CGPoint(x: radius, y: radius), radius2, CGPoint(x: radius2 - 5,y: radius2 - 5), 1, CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        //CGContextDrawPath(context, CGPathDrawingMode.Fill)
        
        CGContextRestoreGState(context)
    }
}