//
//  Slice.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


class Slice {
    // Цвет сектора. По умолчанию прозрачный
  //  var color = UIColor.clear
    
//    var color = [#colorLiteral(red: 0.9420027733, green: 0.7658308744, blue: 0.136086911, alpha: 1),
//                  #colorLiteral(red: 0.9099512696, green: 0.4911828637, blue: 0.1421333849, alpha: 1),
//                  #colorLiteral(red: 0.8836082816, green: 0.3054297864, blue: 0.2412178218, alpha: 1),
//                  #colorLiteral(red: 0.8722914457, green: 0.1358049214, blue: 0.382327497, alpha: 1),
//                  #colorLiteral(red: 0.578535378, green: 0.6434150338, blue: 0.6437515616, alpha: 1),
//                  #colorLiteral(red: 0.07094667107, green: 0.6180127263, blue: 0.5455638766, alpha: 1),
//                  #colorLiteral(red: 0.1627037525, green: 0.4977462888, blue: 0.7221878171, alpha: 1),
//                  #colorLiteral(red: 0.5330474377, green: 0.2909428477, blue: 0.6148440838, alpha: 1),
//                  #colorLiteral(red: 0.5619059801, green: 0.2522692084, blue: 0.4293728471, alpha: 1),
//                  #colorLiteral(red: 0.2041620612, green: 0.3005031645, blue: 0.3878828585, alpha: 1)]
    
    var color = UIColor.red
    var text: String
    var borderColour = UIColor.white
    // Толщина границы
    var borderWidth: CGFloat = 2.5

    init(text: String) {
      //  self.color = color
        self.text = text
    }
}
