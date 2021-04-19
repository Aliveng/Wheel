//
//  Slice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import Foundation
import UIKit


class Slice {
    // Цвет сектора. По умолчанию прозрачный
    var color = UIColor.clear
    // Картинка которая будет показана в секторе
    var image : UIImage
    // Цвет границы
    var borderColour = UIColor.white
    // Толщина границы
    var borderWidth : CGFloat = 2.5
    
    init(image : UIImage) {
        self.image = image
    }
}
