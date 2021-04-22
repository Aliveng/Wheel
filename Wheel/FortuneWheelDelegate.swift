//
//  FortuneWheelDelegate.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 20.04.2021.
//

import UIKit

protocol FortuneWheelDelegate: NSObject {
    
    func shouldSelectObject() -> Int?  // Возвращает индекс сектора, который должен быть выбран.                                     Значение по умолчанию - 1
    func finishedSelecting(index: Int? , error: FortuneWheelError?) // Указывает на окончание
    
}
