//
//  FortuneWheelSlice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import Foundation
import UIKit


class FortuneWheelSlice : CALayer {
    
    private var startAngle : Radians! // Угол начала сектора
    private var sectorAngle : Radians = -1 // Общий угол, который охватывает сектор
    private var slice : Slice! // Объект-сектор, содержащий данные сектора
  
    init(frame : CGRect , startAngle : Radians , sectorAngle : Radians , slice : Slice) {
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
        let center = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2) // Расположение центра колеса
        let image = self.slice.image.rotateImage(angle: self.startAngle)! // Поворот изображения
        let lineLegth = CGFloat((2 * radius * sin(self.sectorAngle/2))) // Длина третьей линии в равнобедренном треугольнике. Расчитана формулой длинны хорды
        let s = (radius + radius + lineLegth)/2 // Половина периметра - используется для расчета размера
        
//     #4
/**size calcutations based on Incenter radius for isosceles triange formula. increased the size by 1.5 instead of 2(as the calculation gives radius and we need diameter) to adjust the image properly inside the slice.*/
        let inCenterDiameter = ((s * (s - radius) * (s - radius) * (s - lineLegth)).squareRoot()/s) * 1.50
        
        //    #5
        /**The size of the image Square*/
        var size : CGFloat = 0 // Размер квадрата изображения
        
        /**Size for 180,120 adn 90 degrees is adjsted manually to properly uitlize the space*/
        size = self.sectorAngle == Degree(180).toRadians() ? radius/2 : self.sectorAngle == Degree(120).toRadians() ?  radius/1.9 : self.sectorAngle == Degree(90).toRadians() ? radius/1.9 : inCenterDiameter
        
        /**Reducing the border width of the lines.in size*/
        size -= self.slice.borderWidth * 3
        
        
        /**Gap between chord and the circumference of the circle at the center of the sector.*/
        let height = 2 * (1 - cos(self.sectorAngle/2))
        
        //      #6
        /**X position of the Incenter of a isosceles triangle.Moved outside a bit to remove the Overlay of image over line.*/
        let xIncenter = ((radius * radius) + ((radius * cos(self.sectorAngle)) * radius))/(radius + radius + lineLegth) + (size * 0.07)
        
        //      #7
        /**Y position of the Incenter of a isosceles triangle*/
        let yIncenter = ((radius * sin(self.sectorAngle)) * radius)/(radius + radius + lineLegth)
        
        //      #8
        //Center alignment of image.180,120 and 90 degrees positions are adjusted manually
        
        let xPosition : CGFloat = self.sectorAngle == Degree(180).toRadians() ? (-size/2) : self.sectorAngle == Degree(120).toRadians() ? (radius/2.7 - size/2) : self.sectorAngle == Degree(90).toRadians() ? (radius/2.4 - size/2) : ((xIncenter - size/2) + height)
        
        let yPosition : CGFloat = self.sectorAngle == Degree(180).toRadians() ? size/1.6 : self.sectorAngle == Degree(120).toRadians() ? (radius/2 - size/2) : self.sectorAngle == Degree(90).toRadians() ? (radius/2.4 - size/2) : (yIncenter - size/2)
        
        
        //Drawing the slice
        
        UIGraphicsPushContext(context)
        
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
        
        //  #9
        //Image draw
        
        context.saveGState()
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: self.startAngle)
        image.draw(in: CGRect.init(x: xPosition, y: yPosition , width: size, height: size))
        context.restoreGState()
        UIGraphicsPopContext()
        
    }
}
