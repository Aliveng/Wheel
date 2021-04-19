//
//  ViewController.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


extension FortuneWheelViewController : FortuneWheelDelegate
{
    func shouldSelectObject() -> Int? {
        return 1
    }
    
    //If you want to get notified when the selection is complete the implement this function also
    func finishedSelecting(index: Int?, error: FortuneWheelError?) {
        
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


class FortuneWheelViewController: UIViewController {
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
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
            fortuineWheel.delegate = self
            self.view.addSubview(fortuineWheel)
        }


    }

