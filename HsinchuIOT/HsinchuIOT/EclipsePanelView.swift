//
//  EclipsePanelView.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/16/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class EclipsePanelView: UIView {
    var shadowColor: UIColor = UIColor(rgba: "#00000033")
    var gradientStartColor: UIColor = UIColor.blackColor()
    var gradientEndColor: UIColor = UIColor.whiteColor()
    
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context);
        
        //first draw shadow
        CGContextSetStrokeColorWithColor(context, shadowColor.CGColor)
        
        CGContextSetFillColorWithColor(context, shadowColor.CGColor)
        
        let offset: CGFloat = 4
        
        var x1: CGFloat = offset
        var y1: CGFloat = offset
        
        var x2: CGFloat = self.frame.width
        var y2: CGFloat = self.frame.height
        
        let radius: CGFloat = (self.frame.height - 5)/2
        
        CGContextMoveToPoint(context, x1, y1 + radius)
        CGContextAddArcToPoint(context, x1, y1, x1 + radius, y1, radius)
        CGContextAddLineToPoint(context, x2 - radius, y1)
        CGContextAddArcToPoint(context, x2, y1, x2, y1 + radius, radius)
        CGContextAddLineToPoint(context, x2, y2 - radius)
        CGContextAddArcToPoint(context, x2, y2, x2 - radius, y2, radius)
        CGContextAddLineToPoint(context, x1 + radius, y2)
        CGContextAddArcToPoint(context, x1, y2, x1, y2 - radius, radius)
        CGContextClosePath(context)
        CGContextDrawPath(context, CGPathDrawingMode.Fill)
        
        
        
        x1 = 0
        y1 = 0
        x2 = self.frame.width - offset
        y2 = self.frame.height - offset
        
        let rgb = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradientCreateWithColors(rgb, [gradientStartColor.CGColor, gradientEndColor.CGColor], [0.0, 1.0])
        
        
        CGContextMoveToPoint(context, x1, y1 + radius)
        CGContextAddArcToPoint(context, x1, y1, x1 + radius, y1, radius)
        CGContextAddLineToPoint(context, x2 - radius, y1)
        CGContextAddArcToPoint(context, x2, y1, x2, y1 + radius, radius)
        CGContextAddLineToPoint(context, x2, y2 - radius)
        CGContextAddArcToPoint(context, x2, y2, x2 - radius, y2, radius)
        CGContextAddLineToPoint(context, x1 + radius, y2)
        CGContextAddArcToPoint(context, x1, y2, x1, y2 - radius, radius)
        CGContextClosePath(context)
        CGContextClip(context)
        
        CGContextDrawLinearGradient(context,
            gradient,
            CGPointMake(0, 0),
            CGPointMake(0, self.frame.height),
            CGGradientDrawingOptions.DrawsAfterEndLocation)
        
        CGContextRestoreGState(context)
    }
}