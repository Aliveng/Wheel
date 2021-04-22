//
//  FortuneWheelSlice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


class FortuneWheelSlice: CALayer {
    
    private var startAngle: Radians! // Угол начала сектора
    private var sectorAngle: Radians = -1 // Общий угол, который охватывает сектор
    private var slice: Slice! // Объект-сектор, содержащий данные сектора
    
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
        let image = self.slice.image.rotateImage(angle: self.startAngle)! // !!! Поворот изображения
        let lineLegth = CGFloat((2 * radius * sin(self.sectorAngle/2))) // Длина третьей линии в равнобедренном треугольнике - секторе. Расчитана формулой длинны хорды
        let s = (radius + radius + lineLegth)/2 // Половина периметра - используется для расчета размера дуги сектора
        
        // !!! Для Изображения
        // Вычисление размеров на основе радиуса для равнобедренного треугольника. Изменен размер на 1,5 вместо 2(так как расчет дает радиус и нам нужен диаметр), чтобы правильно настроить изображение внутри сектора
        let inCenterDiameter = ((s * (s - radius) * (s - radius) * (s - lineLegth)).squareRoot()/s) * 1.50
        var size : CGFloat = 0 // !!! Размер квадрата изображения
        size = self.sectorAngle == Degree(180).toRadians() ? radius/2 : self.sectorAngle == Degree(120).toRadians() ?  radius/1.9 : self.sectorAngle == Degree(90).toRadians() ? radius/1.9 : inCenterDiameter // !!? Для изображения. Размер для 180, 120 и 90 градусов регулируется вручную, чтобы правильно использовать пространство
        size -= self.slice.borderWidth * 3 // !!! Уменьшение ширины границ линий по размеру квадрата изображения
        
        let height = 2 * (1 - cos(self.sectorAngle/2)) // Зазор между хордой и окружностью круга в центре сектора
        
        // !!! X положение центра равнобедренного треугольника. Немного отодвинуто наружу, чтобы убрать наложение изображения на линию
        let xIncenter = ((radius * radius) + ((radius * cos(self.sectorAngle)) * radius))/(radius + radius + lineLegth) + (size * 0.07)
        
        // !!! Y положение центра равнобедренного треугольника
        let yIncenter = ((radius * sin(self.sectorAngle)) * radius)/(radius + radius + lineLegth)
        
        // !!! Выравнивание изображения по центру. положения 180,120 и 90 градусов регулируются вручную
        let xPosition : CGFloat = self.sectorAngle == Degree(180).toRadians() ? (-size/2) : self.sectorAngle == Degree(120).toRadians() ? (radius/2.7 - size/2) : self.sectorAngle == Degree(90).toRadians() ? (radius/2.4 - size/2) : ((xIncenter - size/2) + height)
        let yPosition : CGFloat = self.sectorAngle == Degree(180).toRadians() ? size/1.6 : self.sectorAngle == Degree(120).toRadians() ? (radius/2 - size/2) : self.sectorAngle == Degree(90).toRadians() ? (radius/2.4 - size/2) : (yIncenter - size/2)
        
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
        UIGraphicsPopContext()
        
        // !!! Рисунок изображения
        context.saveGState()
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: self.startAngle)
        image.draw(in: CGRect.init(x: xPosition, y: yPosition , width: size, height: size))
        context.restoreGState()
        UIGraphicsPopContext()
        
    }
}
