//
//  Extensions.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 19.04.2021.
//

import Foundation
import UIKit


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
