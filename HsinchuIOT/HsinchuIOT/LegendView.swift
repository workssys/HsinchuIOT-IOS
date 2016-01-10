//
//  LegendView.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/8/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class LegendView: UIView {
    var _title: String?
    var _color: UIColor = UIColor.blackColor()
    var _font: UIFont = UIFont.systemFontOfSize(8)
    
    var title: String?{
        get{
            return _title
        }
        set{
            _title = newValue
            textLabel.text = _title
        }
    }
    var color: UIColor {
        get{
            return _color
        }
        set{
            _color = newValue
            textLabel.textColor = _color
        }
    }
    
    var font: UIFont {
        get{
            return _font
        }
        set{
            _font = newValue
            textLabel.font = _font
        }
    }
    
    var lineWidth: CGFloat = 1.0
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame: CGRectMake(frame.width/2, 0, frame.width/2, frame.height))
        
        self.addSubview(textLabel)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textLabel = UILabel(frame: CGRectMake(self.frame.width/2, 0, self.frame.width/2, self.frame.height))
        self.addSubview(textLabel)
    }
    
    override func drawRect(rect: CGRect) {
        
        let padding:CGFloat = 4.0
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextSetLineWidth(context, lineWidth);
        
        CGContextMoveToPoint(context, padding, rect.height / 2)
        CGContextAddLineToPoint(context, rect.width/2 - padding, rect.height/2)
        
        CGContextStrokePath(context)
        
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        
        let circleRadis:CGFloat = lineWidth + 2
        
        let circleX = rect.width / 4 - circleRadis
        let circleY = rect.height / 2 - circleRadis
        
        let circleRect = CGRectMake(circleX, circleY, circleRadis * 2, circleRadis * 2 )
        
        CGContextFillRect(context, circleRect)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextAddEllipseInRect(context, circleRect)
    
        CGContextFillPath(context);
    }
    
    
}