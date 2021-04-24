//
//  Slice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


class Slice {
    var color = UIColor.clear
    var text: String
    var borderColour = UIColor.white
    var borderWidth: CGFloat = 2.5

    init(text: String) {
        self.text = text
    }
}
