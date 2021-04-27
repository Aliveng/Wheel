//
//  CarnivalWheelSlice.swift
//  TTFortuneWheelSample
//
//  Created by Efraim Budusan on 11/1/17.
//  Copyright © 2017 Tapptitude. All rights reserved.
//

import Foundation
import UIKit

public class LilacWheelSlice: SpinningWheelSliceProtocol {
    
    public enum Style {
        case sliceOne
        case sliceTwo
    }
    
    public var title: String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .sliceOne: return .sliceOne
        case .sliceTwo: return .sliceTwo
        }
    }
    
    public var fontColor: UIColor {
        return UIColor.white
    }
    
    public var offsetFromExterior:CGFloat {
        return 18.0
    }
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: 12)
//        switch style {
//        case .sliceOne: return UIFont(name: "ChunkFive", size: 22.0)!
//        }
    }
    
    public var style: Style = .sliceOne
    
    public init(title:String) {
        self.title = title
    }
    
    public convenience init(title:String, degree:CGFloat) {
        self.init(title:title)
        self.degree = degree
    }
}
