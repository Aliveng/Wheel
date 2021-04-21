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
        
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.showFortuneWheel()
        
    }
    //Назначает центральную точку CGPoint колеса и диаметр сегментов
    func showFortuneWheel() {
        var slices = [Slice]()
        for i in 1...10 {
            //Здесь вызываются изображения, из assets с именами от 1 до 5
            let slice = Slice.init(image: UIImage.init(named: "\(i <= 5 ? i : (i - 5))")!)
            slice.color = .random()
            slices.append(slice)
        }
        
        let fortuineWheel = FortuneWheel.init(center: CGPoint.init(x: self.view.frame.width/2,
                                                                   y: self.view.frame.height/2),
                                                            diameter: 400, slices: slices)
        fortuineWheel.delegate = self
        self.view.addSubview(fortuineWheel)
    }
}

extension FortuneWheelViewController : FortuneWheelDelegate {
    // Сектор котрый получаем при отработке
    func shouldSelectObject() -> Int? {
        return 1
    }
    // Получить уведомление о завершении выбора
    func finishedSelecting(index: Int?, error: FortuneWheelError?) {
    }
}
