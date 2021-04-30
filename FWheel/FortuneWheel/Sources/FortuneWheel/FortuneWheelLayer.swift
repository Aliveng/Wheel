//
//  FortuneWheelLayer.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit
import CoreGraphics


open class FortuneWheelLayer: CALayer  {
    
    // Используется для центрирования рисунка таким образом, чтобы смещенная графика(например, тень) не обрезалась
    // Может быть увеличен до любого размера
    open var layerInsets: UIEdgeInsets = UIEdgeInsets(top: -50, left: -50, bottom: -50, right: -50)
    
    var mainFrame: CGRect!
    weak var parent: FortuneWheel!
    private var initialOffset: CGFloat!
    
    public init(frame: CGRect, parent:FortuneWheel, initialOffset: CGFloat = 0.0) {
        super.init()
        mainFrame = CGRect(origin: CGPoint(x: abs(layerInsets.left),
                                           y: abs(layerInsets.top)),
                           size: frame.size)
        self.frame = frame.inset(by: layerInsets)
        self.parent = parent
        self.initialOffset = initialOffset
        self.backgroundColor = UIColor.clear.cgColor
        self.contentsScale = UIScreen.main.scale
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        guard parent.slices != nil else {
            assert(false, "Slices parameter not set")
            return
        }
        UIGraphicsPushContext(ctx)
        drawCanvas(mainFrame: mainFrame)
        UIGraphicsPopContext()
    }
    
    open func drawCanvas(mainFrame: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        if let shadow = parent.shadow {
            context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        }
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        // Отрисовка секторов
        var rotation: CGFloat = initialOffset
        parent.slices.enumerated().forEach { (index,element) in
            if let previousSlice = parent.slices[safe: (index - 1)] {
                rotation += (degree(of: previousSlice) + degree(of: element)) / 2
            }
            self.drawSlice(withIndex: index, in: context, forSlice: element, rotation: rotation)
        }
        
        // Дополнительная графика
        parent.slices.enumerated().forEach { (index,element) in
            self.drawAdditionalGraphics(in: context, rotation: rotation, for: element)
            let previousSlice:SpinningWheelSliceProtocol = parent.slices[safe: (index - 1)] ?? element
            rotation += degree(of:previousSlice)
        }
        
        // Отрисовка рамки
        let circleFrame = UIBezierPath(ovalIn: mainFrame)
        parent.frameStroke.color.setStroke()
        circleFrame.lineWidth = parent.frameStroke.width
        circleFrame.stroke()
        
        context.endTransparencyLayer()
        context.restoreGState()
    }
    
    // Вычесленные значения и выражения
    private var radius: CGFloat { return mainFrame.height / 2.0 }
    private var rotationOffset: CGFloat { return (mainFrame.width) / 2 + abs(layerInsets.top) }
    private func circularSegmentHeight(from degree: CGFloat) -> CGFloat { return 2 * radius * sin(degree / 2.0 * CGFloat.pi/180) }
    
    private func degree(of slice:SpinningWheelSliceProtocol) -> CGFloat {
        return parent.sliceDegree ?? slice.degree
    }
    
    // Отрисовка графики
    open func drawSlice(withIndex index:Int, in context:CGContext, forSlice slice:SpinningWheelSliceProtocol, rotation:CGFloat) {
        // Объявление констант
        let sectionWidthDegrees = degree(of: slice)
        let kTitleOffset: CGFloat = slice.offsetFromExterior
        let titleXValue: CGFloat = mainFrame.minX + kTitleOffset
        let kTitleWidth: CGFloat = 0.6
        let titleWidthCoeficient: CGFloat = sin(sectionWidthDegrees / 2.0 * CGFloat.pi/180)
        let titleWidthValue: CGFloat = (kTitleWidth + titleWidthCoeficient * 0.2) * radius
        let startAngle: CGFloat = 180 + sectionWidthDegrees / 2.0
        let endAngle: CGFloat = 180 - sectionWidthDegrees / 2.0
        let circularSegmentHeight: CGFloat = self.circularSegmentHeight(from:sectionWidthDegrees)
        let titleHeightValue: CGFloat = circularSegmentHeight * 1
        let titleYPosition: CGFloat = mainFrame.minY + mainFrame.height / 2.0 - titleHeightValue / 2.0
        
        // Настройка контекста
        context.saveGState()
        context.translateBy(x: rotationOffset, y: rotationOffset)
        context.rotate(by: rotation * CGFloat.pi/180)
        
        // Отрисовка сектора
        let sliceRect = CGRect(x: (mainFrame.minX - rotationOffset), y: (mainFrame.minY - rotationOffset), width: mainFrame.width, height: mainFrame.height)
        let slicePath = UIBezierPath()
        slicePath.addArc(withCenter: CGPoint(x: sliceRect.midX,
                                             y: sliceRect.midY),
                         radius: sliceRect.width / 2,
                         startAngle: -startAngle * CGFloat.pi/180,
                         endAngle: -endAngle * CGFloat.pi/180,
                         clockwise: true)
        
        slicePath.addLine(to: CGPoint(x: sliceRect.midX,
                                      y: sliceRect.midY))
        slicePath.close()
        slice.backgroundColor?.setFill()
        slicePath.fill()
        
        // Отрисовка текста
        let textRect = CGRect(x: (titleXValue - rotationOffset), y: (titleYPosition - rotationOffset), width: titleWidthValue, height: titleHeightValue)
        let textTextContent = slice.title
        
        // Атрибуты текста
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        var textFontAttributes = slice.textAttributes
        textFontAttributes[.paragraphStyle] = textStyle
        
        let textBoundingRect = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil)
        let textTextHeight: CGFloat = textBoundingRect.height
        context.saveGState()
        
        context.translateBy(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2)
        context.translateBy(x: textBoundingRect.width / 2, y: textBoundingRect.height / 2)
        context.rotate(by: self.parent.titleRotation)
        context.translateBy(x: -(textBoundingRect.width / 2), y: -(textBoundingRect.height / 2))
        context.clip(to: CGRect(x: 0, y: 0, width: textRect.width, height: textRect.height))
        textTextContent.draw(in: CGRect(x: 0, y: 0, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
        
        context.restoreGState()
    }
    
    private func drawAdditionalGraphics(in context:CGContext, rotation:CGFloat, for slice: SpinningWheelSliceProtocol) {
        let sectionWidthDegrees: CGFloat = degree(of: slice)
        let circularSegmentHeight: CGFloat = self.circularSegmentHeight(from: sectionWidthDegrees)
        context.saveGState()
        context.translateBy(x: rotationOffset, y: rotationOffset)
        context.rotate(by: rotation * CGFloat.pi/180)
        slice.drawAdditionalGraphics(in: context,circularSegmentHeight: circularSegmentHeight, radius: radius,sliceDegree:sectionWidthDegrees)
        context.restoreGState()
    }
}
