//
//  FortuneWheelSliceProtocol.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit


public struct StrokeInfo {
    public var color: UIColor
    public var width: CGFloat

    public init(color: UIColor, width: CGFloat) {
        self.color = color
        self.width = width
    }
}

public protocol SpinningWheelSliceProtocol {
    
    var title: String { get }
    var backgroundColor: UIColor? { get }
    var degree: CGFloat { get }
    var offsetFromExterior: CGFloat { get }
    
    // Любые текстовые атрибуты, кроме NSMutableParagraphStyle, которые всегда будут центрированы
    var textAttributes: [NSAttributedString.Key: Any] { get }
    
    // Можно переписать под себя, если есть в textAttributes
    var fontSize: CGFloat { get }
    var fontColor: UIColor { get }
    var font: UIFont { get }
    
    // Можно использовать, если нужно добавить дополнительную графику в сектор
    // Начало координат находится в центре главной окружности
    // Придется динамически вычислить положение элементов, используя высоту окружности и радиус
    func drawAdditionalGraphics(in context: CGContext, circularSegmentHeight: CGFloat,radius: CGFloat,sliceDegree: CGFloat)
}

extension SpinningWheelSliceProtocol {
    
    public func drawAdditionalGraphics(in context: CGContext, circularSegmentHeight: CGFloat,radius: CGFloat,sliceDegree: CGFloat) {
    }
    public var fontSize: CGFloat { return 18.0 }
    public var fontColor: UIColor { return UIColor.black }
    public var font: UIFont { return UIFont.systemFont(ofSize: fontSize, weight: .regular) }
    
    public var textAttributes:[NSAttributedString.Key: Any] {
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let deafultAttributes: [NSAttributedString.Key: Any] =
            [.font: self.font,
             .foregroundColor: self.fontColor,
             .paragraphStyle: textStyle ]
        return deafultAttributes
    }
}
