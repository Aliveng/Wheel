//
//  ViewController.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


class FortuneWheelViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            self.ShowFortuneWheel()
        }
        
        //Assign the center CGPoint for the wheel and a diameter adn the slices it should show and conform to the protocol
        func ShowFortuneWheel()
        {
            var slices = [Slice]()
            for i in 1...10
            {
                //The images form assets naming from 1 to 5 are called here.
                let slice = Slice.init(image: UIImage.init(named: "\(i <= 5 ? i : (i - 5))")!)
                slice.color = .random()
                slices.append(slice)
            }
            let fortuineWheel = FortuneWheel.init(center: CGPoint.init(x: self.view.frame.width/2, y: self.view.frame.height/2), diameter: 300, slices: slices)
            self.view.addSubview(fortuineWheel)
        }


    }

    //Some additional methods which creates random color.
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
