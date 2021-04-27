//
//  ViewController.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.8
        label.textColor = .titleColor
        label.textAlignment = .center
        label.text = "Колесо Фартуны"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.4
        label.textColor = .bottomTextColor
        label.textAlignment = .center
        label.text = "Описание подсказки в несколько строк.\nВы можете крутить колесо фартуны и участвовать в акциях"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var arrowView: UIImageView = {
        let arrow = UIImageView()
        arrow.image = .arrow
        return arrow
    }()
    
    lazy var rotateButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.backgroundColor = .sliceTwo
        //  button.frame = CGRect(x: spinningWheel.center.x, y: spinningWheel.center.y, width: 50, height: 50)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.borderWheel.cgColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapRotateButton), for: .touchUpInside)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue, UIColor.red]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.locations = [0.0 , 1.0]
        gradient.frame = button.frame
        
        button.layer.insertSublayer(gradient, at: 0)
        
        return button
    }()
    
    lazy var spinningWheel: FortuneWheel = {
        let spinningWheel = FortuneWheel(frame: .zero, slices: [])
        
        let slices = [ LilacWheelSlice.init(title: "42 %"),
                       LilacWheelSlice.init(title: "15 %"),
                       LilacWheelSlice.init(title: "Название"),
                       LilacWheelSlice.init(title: "42 %"),
                       LilacWheelSlice.init(title: "скидка 6 %"),
                       LilacWheelSlice.init(title: "Название"),
                       LilacWheelSlice.init(title: "42 %"),
                       LilacWheelSlice.init(title: "скидка 5 %")]
        
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 1
        spinningWheel.titleRotation = CGFloat.pi
        
        return spinningWheel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(spinningWheel)
        view.addSubview(rotateButton)
        view.addSubview(titleLabel)
        view.addSubview(bottomLabel)
        view.addSubview(arrowView)
        
        spinningWheel.snp.makeConstraints {
            $0.height.width.equalTo(227.97)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(39)
            $0.bottom.equalTo(spinningWheel.snp.top).offset(-30)
        }
        
        bottomLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(39)
            $0.top.equalTo(spinningWheel.snp.bottom).offset(30)
        }
        
        rotateButton.snp.makeConstraints {
            $0.height.width.equalTo(45.59)
            $0.center.equalTo(spinningWheel.snp.center)
        }
        
        arrowView.snp.makeConstraints {
            $0.height.width.equalTo(29.64)
            $0.left.equalTo(spinningWheel.snp.right).inset(10) // насколько заходит на колесо
            $0.centerY.equalToSuperview()
        }
        
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! LilacWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0: slice.style = .sliceTwo
            case 1: slice.style = .sliceOne
            case 2: slice.style = .sliceTwo
            case 3: slice.style = .sliceOne
            default: slice.style = .sliceTwo
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
