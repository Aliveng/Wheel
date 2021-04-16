//
//  FortuneWheelError.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//


import Foundation
import UIKit

class FortuneWheelError: Error {
    
    let message : String
    let code : Int
    init(message : String , code : Int) {
        self.message = message
        self.code = code
    }
    
}
