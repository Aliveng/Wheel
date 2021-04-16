//
//  FortuneWheelSlice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import Foundation
import UIKit

class FortuneWheelSlice : CALayer
{
    typealias Radians = CGFloat
    
    /**Angle where the slice begins*/
    private var startAngle : Radians!
    
    /**Total angle the sector covers*/
    private var sectorAngle : Radians = -1
    
    /**Slice object which contains the slice data*/
    private var slice : Slice!

    /**Start Angle is the angle where the sector begins and sector angle is the angle the sector covers*/
    init(frame : CGRect , startAngle : Radians , sectorAngle : Radians , slice : Slice)
    {
        super.init()
        
        self.startAngle = startAngle
        self.sectorAngle = sectorAngle
        self.slice = slice
        self.frame = frame.inset(by: UIEdgeInsets.init(top: -10, left: 0, bottom: -10, right: 0))
        
        //Images where appearing distorted setting the scale solve dthe issue.
        self.contentsScale = UIScreen.main.scale
        self.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext)
    {
       /**The radius of the wheel*/
       let radius = self.frame.width/2 - self.slice.borderWidth
      
       /**The center position of the wheel*/
       let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
       
       //Drawing the slice
            
       UIGraphicsPushContext(ctx)
       
      // #1
       let path = UIBezierPath.init()
       path.lineWidth = self.slice.borderWidth
       path.move(to: center)
       path.addArc(withCenter: center, radius: radius, startAngle: self.startAngle, endAngle: self.startAngle + self.sectorAngle, clockwise: true)
       path.close()
       //applies the slice color
       self.slice.color.setFill()
       path.fill()
       //Applies border color
       self.slice.borderColour.setStroke()
       path.stroke()
       UIGraphicsPopContext()
        
        
    }
    
}
