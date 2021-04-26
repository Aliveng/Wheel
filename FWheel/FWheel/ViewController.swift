//
//  ViewController.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setTitle("one", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(didTapRotateButton), for: .touchUpInside)
        return button
    }()
    
    lazy var spinningWheel: TTFortuneWheel = {
        let spinningWheel = TTFortuneWheel(frame: .zero, slices: [])
        
        let slices = [ CarnivalWheelSlice.init(title: "Roller Coaster"),
                       CarnivalWheelSlice.init(title: "Try again"),
                       CarnivalWheelSlice.init(title: "Free\nticket"),
                       CarnivalWheelSlice.init(title: "Teddy\nbear"),
                       CarnivalWheelSlice.init(title: "Large popcorn"),
                       CarnivalWheelSlice.init(title: "Balloon figures"),
                       CarnivalWheelSlice.init(title: "Ferris Wheel"),
                       CarnivalWheelSlice.init(title: "Pony\nRide")]
        
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 0
        spinningWheel.titleRotation = CGFloat.pi
        
       return spinningWheel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(spinningWheel)
        view.addSubview(rotateButton)
        
        spinningWheel.snp.makeConstraints {
            $0.height.width.equalTo(337)
            $0.center.equalToSuperview()
        }
        
        rotateButton.snp.makeConstraints {
            $0.height.width.equalTo(70)
            $0.center.equalTo(spinningWheel.snp.center)
        }
        
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0: slice.style = .brickRed
            case 1: slice.style = .sandYellow
            case 2: slice.style = .babyBlue
            case 3: slice.style = .deepBlue
            default: slice.style = .brickRed
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   @objc func didTapRotateButton() {

        spinningWheel.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.spinningWheel.startAnimating(fininshIndex: 5) { (finished) in
                print(finished)
            }
        }
    }
}
