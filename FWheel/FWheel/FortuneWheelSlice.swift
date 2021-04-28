//
//  FortuneWheelSlice.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit

// Базовая реализация сектора
public class FortuneWheelSlice: SpinningWheelSliceProtocol {
    
    public var offsetFromExterior: CGFloat = 10
    
    public enum Style {
        case dark
        case light
    }
    
    public var title: String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .dark: return .darkStyle
        case .light: return UIColor.white
        }
    }
    
    public var fontColor: UIColor {
        switch style {
        case .dark: return UIColor.white
        case .light: return .darkStyle
        }
    }
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    public var style: Style = .dark
    public init(title: String) {
        self.title = title
    }
    
    public convenience init(title: String, degree: CGFloat) {
        self.init(title: title)
        self.degree = degree
    }
    
    public func drawAdditionalGraphics(in context: CGContext, circularSegmentHeight: CGFloat, radius: CGFloat, sliceDegree: CGFloat) {
        let image = UIImage(named: "niddleImage", in: Bundle.sw_frameworkBundle(), compatibleWith: nil)!
        let centerOffset = CGPoint(x: -64, y: 17)
        let additionalGraphicRect = CGRect(x: centerOffset.x, y: centerOffset.y, width: 12, height: 12)
        let additionalGraphicPath = UIBezierPath(rect: additionalGraphicRect)
        context.saveGState()
        additionalGraphicPath.addClip()
        context.scaleBy(x: 1, y: -1)
        context.draw(image.cgImage!, in: CGRect(x: additionalGraphicRect.minX, y: -additionalGraphicRect.minY, width: image.size.width, height: image.size.height), byTiling: true)
        context.restoreGState()
    }
}
