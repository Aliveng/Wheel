//
//  FortuneWheelSliceProtocol.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import Foundation
import UIKit

public struct StrokeInfo {
    public var color:UIColor
    public var width:CGFloat
    
    public init(color:UIColor, width:CGFloat) {
        self.color = color
        self.width = width
    }
}

public protocol FortuneWheelSliceProtocol {
    
    //// Properties
    var title:String { get }
    var backgroundColor:UIColor? { get }
    var degree:CGFloat { get }
  //  var stroke:StrokeInfo? { get }
    var offsetFromExterior:CGFloat { get }
    
    //// Can provide any text attributes except NSMutableParagraphStyle which will allways be centered
    var textAttributes: [NSAttributedString.Key:Any] { get }
    
    //// Can be overriten individualy. textAttributes is used if set.
    var fontSize:CGFloat { get }
    var fontColor:UIColor { get }
    var font:UIFont { get }
    
    /// Implement if you want to add additional graphic to a slice.
    /// Note the origin of coordinate system is at the center of the main circle.
    /// You will have to dinamically compute the positon of your elements using the circularSegmentHeight and the radius
    func drawAdditionalGraphics(in context:CGContext, circularSegmentHeight:CGFloat,radius:CGFloat,sliceDegree:CGFloat)
}

extension FortuneWheelSliceProtocol {
    
    public func drawAdditionalGraphics(in context:CGContext, circularSegmentHeight:CGFloat,radius:CGFloat,sliceDegree:CGFloat) { }
    
    public var fontSize:CGFloat { return 18.0 }
    public var fontColor:UIColor { return UIColor.black }
    public var font:UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .regular) }
    
    public var textAttributes:[NSAttributedString.Key:Any] {
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let deafultAttributes:[NSAttributedString.Key: Any] =
                [.font: self.font,
                 .foregroundColor: self.fontColor,
                 .paragraphStyle: textStyle ]
        return deafultAttributes
    }
}
