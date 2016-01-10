//
//  ChartPointPopupView.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/10/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import SwiftCharts

public class ChartPointPopupView: UIView {
    
    private let targetCenter: CGPoint
    
    var pointDiameter: CGFloat
    
    public var viewTapped: ((ChartPointPopupView) -> ())?
    
    var pointColor: UIColor = UIColor.grayColor()
    var textColor: UIColor = UIColor.grayColor()
    var selectedPointColor: UIColor = UIColor.whiteColor()
    var selectedTextColor: UIColor = UIColor.whiteColor()
    
    var hideText: Bool = true
    
    var textLabel: UILabel!
    
    var textSize: CGSize!
    
    var textVPadding: CGFloat = 0
    
    
    var animDelay: Float = 0
    var animDuration: Float = 0
    var animateSize: Bool = true
    var animateAlpha: Bool = true
    var animDamping: CGFloat = 1
    var animInitSpringVelocity: CGFloat = 1
    
    
    
    public var selected: Bool = false {
        didSet {
            if self.selected {
                self.textLabel.textColor = selectedTextColor
            } else {
                self.textLabel.textColor = textColor
            }
            self.setNeedsDisplay()
        }
    }
    
    public init(chartPoint: ChartPoint, center: CGPoint, diameter: CGFloat, pointColor: UIColor, selectedPointColor:UIColor, hideText: Bool, textFont: UIFont, textVerticalPadding: CGFloat, textColor: UIColor, selectedTextColor: UIColor) {
        
        self.targetCenter = center
        self.pointDiameter = diameter
        
        if hideText {
            self.textSize = CGSize(width: 0, height: 0)
            self.textVPadding = 0
            
        }else{
            let t: NSString = chartPoint.y.text
            self.textSize = t.sizeWithAttributes([NSFontAttributeName:textFont])
            self.textVPadding = textVerticalPadding
        }
        
        var frameWidth = textSize.width
        if frameWidth < pointDiameter {
            frameWidth = pointDiameter
        }
        
        
        super.init(frame: CGRectMake(-frameWidth / 2 , targetCenter.y - pointDiameter / 2 - textSize.height - textVPadding, frameWidth, pointDiameter + textSize.height + textVPadding))
        
        
        self.pointColor = pointColor
        self.selectedPointColor = selectedPointColor
        
        self.textLabel = UILabel(frame: CGRectMake(0, 0, textSize.width, textSize.height))
        self.textLabel.font = textFont
        self.textLabel.textColor = textColor
        self.textLabel.text = chartPoint.y.text
        self.textLabel.textAlignment = NSTextAlignment.Center
        self.textLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(textLabel)
        
        if hideText {
            self.textLabel.hidden = true
        }
        
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        
        
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    override public func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            let w: CGFloat = self.frame.size.width
            let h: CGFloat = self.frame.size.height
            
            let frame = CGRectMake(self.targetCenter.x - (w/2), self.targetCenter.y - self.textSize.height - self.textVPadding - self.pointDiameter / 2, w, h)
            self.frame = frame
            
            }, completion: {finished in})
        
    }
    
    
    public override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        var frameWidth = textSize.width
        if frameWidth < pointDiameter {
            frameWidth = pointDiameter
        }
        
        let circleRect = (CGRectMake(frameWidth/2 - pointDiameter/2, textSize.height + textVPadding, pointDiameter, pointDiameter))
        
            CGContextSetLineWidth(context, 0)
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            CGContextStrokeEllipseInRect(context, circleRect)
        if selected {
            CGContextSetFillColorWithColor(context, self.selectedPointColor.CGColor)
        }else{
            CGContextSetFillColorWithColor(context, self.pointColor.CGColor)
        }
        CGContextFillEllipseInRect(context, circleRect)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        viewTapped?(self)
    }
}