//
//  Extensions.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 19.04.2021.
//

import Foundation
import UIKit


typealias Radians = CGFloat
typealias Degree = CGFloat

extension Degree { // Градусы в Радианы
    func toRadians() -> Radians {
        return (self * .pi) / 180.0
    }
}

extension FortuneWheelViewController : FortuneWheelDelegate {
    // Сектор котрый получаем при отработке
    func shouldSelectObject() -> Int? {
        return 1
    }
    // Получить уведомление о завершении выбора
    func finishedSelecting(index: Int?, error: FortuneWheelError?) {
        
    }
}

// Дополнительные методы, которые создают случайный цвет
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension UIImage {
    func rotateImage(angle:Radians) -> UIImage? {
        let ciImage = CIImage(image: self)
        let filter = CIFilter(name: "CIAffineTransform")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setDefaults()
        let newAngle = angle * CGFloat(1)
        var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        let affineTransform = CATransform3DGetAffineTransform(transform)
            filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        let contex = CIContext(options: [CIContextOption.useSoftwareRenderer:true])
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        let result = UIImage(cgImage: cgImage!)
        return result
    }
}
