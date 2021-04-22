//
//  FortuneWheelSlice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit
import CoreGraphics


class FortuneWheelSlice: CALayer {
    
    private var startAngle: Radians! // Угол начала сектора
    private var sectorAngle: Radians = -1 // Общий угол, который охватывает сектор
    private var slice: Slice! // Объект-сектор, содержащий данные сектора
    var sliceIndex: CGFloat = 0
    
    init(frame: CGRect, startAngle: Radians, sectorAngle: Radians, slice: Slice) {
        super.init()
        self.startAngle = startAngle // Это угол, под которым начинается сектор
        self.sectorAngle = sectorAngle // Это угол, который охватывает сектор
        self.slice = slice
        self.frame = frame.inset(by: UIEdgeInsets.init(top: -10, left: 0, bottom: -10, right: 0))
        
        // Решение проблемы искажения изображений при масштабировании
        self.contentsScale = UIScreen.main.scale
        self.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in context: CGContext) {
        
        let radius = self.frame.width/2 - self.slice.borderWidth // Радиус колеса
        let center = CGPoint.init(x: self.frame.width/2,
                                  y: self.frame.height/2) // Расположение центра колеса
        let text = self.slice.text
        
        // Отрисовка сектора
        UIGraphicsPushContext(context)
        
        let path = UIBezierPath.init()
        path.lineWidth = self.slice.borderWidth
        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: self.startAngle,
                    endAngle: self.startAngle + self.sectorAngle,
                    clockwise: true)
        path.close()
        // Заполняет цветом сектор
        self.slice.color.setFill()
        path.fill()
        // Заполняет цветом контур - обводку
        self.slice.borderColour.setStroke()
        path.stroke()
        
        (text as NSString).draw(at: CGPoint(x: self.position.x + (10 * sliceIndex), y: self.position.y + 0), withAttributes: [:])
        
        UIGraphicsPopContext()
    }
}
