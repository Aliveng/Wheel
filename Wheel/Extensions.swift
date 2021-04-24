//
//  Extensions.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 19.04.2021.
//

import UIKit


typealias Radians = CGFloat
typealias Degree = CGFloat

extension Degree { // Градусы в Радианы
    func toRadians() -> Radians {
        return (self * .pi) / 180.0
    }
}
