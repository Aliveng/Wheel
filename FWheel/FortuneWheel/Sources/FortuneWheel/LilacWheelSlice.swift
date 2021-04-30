//
//  CarnivalWheelSlice.swift
//  TTFortuneWheelSample
//
//  Created by Efraim Budusan on 11/1/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import Foundation
import UIKit

// Вид колеса согласно дизайну
public class LilacWheelSlice: SpinningWheelSliceProtocol {
    
    public var title: String
    public var degree: CGFloat = 0.0
    public var backgroundColor: UIColor? = UIColor.clear
    public var fontColor: UIColor = UIColor.clear
    
    public var offsetFromExterior: CGFloat { // отступ надписи сектора от края колеса
        return 18.0
    }
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: 12)
// Можно установить разные шрифты для секторов
//        switch style {
//        case .sliceOne: return UIFont(name: "", size: 22.0)!
//        case .sliceTwo: return UIFont(name: "", size: 20.0)!
//        }
    }
    
    public init(title: String, fontColor: UIColor, backgroundColor: UIColor) {
        self.title = title
        self.fontColor = fontColor
        self.backgroundColor = backgroundColor
    }
    
    public convenience init(title:String, degree:CGFloat, fontColor: UIColor, backgroundColor: UIColor) {
        self.init(title: title, fontColor: fontColor, backgroundColor: backgroundColor)
        self.degree = degree
    }
}
