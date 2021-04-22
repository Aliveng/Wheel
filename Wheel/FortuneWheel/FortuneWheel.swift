//
//  FortuneWheel.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import UIKit


class FortuneWheel: UIView {
    
    weak var delegate: FortuneWheelDelegate?
    
    // View - Колесо на котором будут нарисованы сектора
    private var wheelView: UIView!
    
    // Угол, который занимает каждый сектор
    private var sectorAngle: Radians = 0
    
    // Кнопка, запускающая колесо. Расположена в его центре
    var playButton: UIButton = UIButton.init(type: .custom)
    
    // ImageView стрелки-индикатора
    private var indicator = UIImageView.init()
    
    // Размер стрелки-индикатора
    private lazy var indicatorSize: CGSize = {
        let size = CGSize.init(width: self.bounds.width * 0.126 ,
                               height: self.bounds.height * 0.126)
        return size }()
    
    // Количество секторов в колесе, определяется массивом объектов, где каждый содержит данные секторов
    private var slices: [Slice]?
    
    //Инициализируем колесо с центром в CGPoint, диаметром и секторами
    init(center: CGPoint, diameter: CGFloat, slices: [Slice]) {
        super.init(frame: CGRect.init(origin: CGPoint.init(x: center.x - diameter/2,
                                                           y: center.y - diameter/2),
                                                        size: CGSize.init(width: diameter,
                                                                          height: diameter)))
        self.slices = slices
        self.initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selectionIndex : Int = -1 // Индекс, который должен быть выбран при нажатии кнопки
    private var selectionAngle : Radians = 0 // Угол выбора, вычисленный в методе выполнения выбора, который будет использоваться для преобразования вида колеса после завершения анимации
    
    // Сборка элементов колеса
    private func initialSetUp() {
        
        self.backgroundColor = .clear
        self.addWheelView()
        self.addStartButton()
        self.addIndicator()
    }
    
    func performSelection() { // Выполнение вращения - выбора сектора
        var selectionSpinDuration: Double = 1 // задержка последней анимации выбора, до заданого сектора
        
        self.selectionAngle = Degree(360).toRadians() - (self.sectorAngle * CGFloat(self.selectionIndex))
        let borderOffset = self.sectorAngle * 0.1
        self.selectionAngle -= Radians.random(in: borderOffset...(self.sectorAngle - borderOffset))
        
        // Если выбраный угол отрицательный, то он изменяется на положительный. Отрицательное значение вращает колесо в обратном направлении
        if self.selectionAngle < 0 {
            self.selectionAngle = Degree(360).toRadians() + self.selectionAngle
            selectionSpinDuration += 0.5
        }
        
        var delay : Double = 0 // Задержка начала вращения после нажатия кнопки
        
        // Быстрое вращение колеса
        let fastSpin = CABasicAnimation.init(keyPath: "transform.rotation")
        fastSpin.fromValue = NSNumber.init(floatLiteral: 0)
        fastSpin.toValue = NSNumber.init(floatLiteral: .pi * 2)
        fastSpin.duration = 0.7
        fastSpin.repeatCount = 3
        fastSpin.beginTime = CACurrentMediaTime() + delay
        delay += Double(fastSpin.duration) * Double(fastSpin.repeatCount)
        
        // Немного замедляет вращение, начинается сразу после завершения быстрого вращения
        let slowSpin = CABasicAnimation.init(keyPath: "transform.rotation")
        slowSpin.fromValue = NSNumber.init(floatLiteral: 0)
        slowSpin.toValue = NSNumber.init(floatLiteral: .pi * 2)
        slowSpin.isCumulative = true
        slowSpin.beginTime = CACurrentMediaTime() + delay
        slowSpin.repeatCount = 1
        slowSpin.duration = 1.5
        delay += Double(slowSpin.duration) * Double(slowSpin.repeatCount)
        
        // Вращение колеса к сектору, который должен быть выбран. Начинается сразу после медленного вращения
        let selectionSpin = CABasicAnimation.init(keyPath: "transform.rotation")
        selectionSpin.delegate = self
        selectionSpin.fromValue = NSNumber.init(floatLiteral: 0)
        selectionSpin.toValue = NSNumber.init(floatLiteral: Double(self.selectionAngle))
        selectionSpin.duration = selectionSpinDuration
        selectionSpin.beginTime = CACurrentMediaTime() + delay
        selectionSpin.isCumulative = true
        selectionSpin.repeatCount = 1
        selectionSpin.isRemovedOnCompletion = false
        selectionSpin.fillMode = .forwards
        
        // Анимации добавляются к колесу
        self.wheelView.layer.add(fastSpin, forKey: "fastAnimation")
        self.wheelView.layer.add(slowSpin, forKey: "SlowAnimation")
        self.wheelView.layer.add(selectionSpin, forKey: "SelectionAnimation")
    }
    
    // Уведомление о завершении выбора или любых ошибках, возникших через делегат
    private func performFinish(error : FortuneWheelError? ) {
        if let error = error {
            self.delegate?.finishedSelecting(index: nil, error: error)
        }
        else {
            //Когда анимация завершена, трансформацией фиксируется положение колеса на заданый угол
            self.wheelView.transform = CGAffineTransform.init(rotationAngle:self.selectionAngle)
            self.delegate?.finishedSelecting(index: self.selectionIndex, error: nil)
        }
        if !self.playButton.isEnabled {
            self.playButton.isEnabled = true
        }
    }
    
    // Добавляет View колеса с секторами
    private func addWheelView() {
        let width = self.bounds.width - self.indicatorSize.width
        let height = self.bounds.height - self.indicatorSize.height
        // Выровневоние колеса с секторами по центру колеса подложки
        let xPosition : CGFloat = (self.bounds.width/2) - (width/2)
        let yPosition : CGFloat = (self.bounds.height/2) - (height/2)
        self.wheelView = UIView.init(frame: CGRect.init(x: xPosition,
                                                        y: yPosition,
                                                        width: width,
                                                        height: height))
        self.wheelView.backgroundColor = .black
        self.wheelView.layer.cornerRadius = width/2
        self.wheelView.clipsToBounds = true
        self.addSubview(self.wheelView)
        // Отрисовка секторов
        self.addWheelLayer()
    }
    
    // Добавляет стрелку-индикатор
    private func addIndicator() {
        //Положение индикатора (половина перекрывала колесо, а остальная часть выходила за пределы, и расположение в центре правой стороны колеса, то есть под углом 0 градусов)
        let position = CGPoint.init(x: self.frame.width - self.indicatorSize.width,
                                    y: self.bounds.height/2 - self.indicatorSize.height/2)
        self.indicator.frame = CGRect.init(origin: position,
                                           size: self.indicatorSize)
        self.indicator.image = UIImage.init(named: "pointer")
        if self.indicator.superview == nil {
            self.addSubview(self.indicator)
        }
    }
    
    // Добавляет кнопку Play
    private func addStartButton() {
        let size = CGSize.init(width: self.bounds.width * 0.20,
                               height: self.bounds.height * 0.20)
        let point = CGPoint.init(x: self.frame.width/2 - size.width/2,
                                 y: self.frame.height/2 - size.height/2)
        self.playButton.setTitle("Start!", for: .normal)
        playButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.playButton.frame = CGRect.init(origin: point,
                                            size: size)
        self.playButton.addTarget(self, action: #selector(startAction(sender:)), for: .touchUpInside)
        self.playButton.layer.cornerRadius = self.playButton.frame.height/2
        self.playButton.clipsToBounds = true
        self.playButton.backgroundColor = .white
        self.playButton.layer.borderWidth = 0.5
        self.playButton.layer.borderColor = UIColor.black.cgColor
        self.addSubview(self.playButton)
    }
    
    @objc private func startAction(sender: UIButton) {
        self.playButton.isEnabled = false
        if let slicesCount = self.slices?.count {
            // Запрашивает делегат для индекса, который должен быть выбран. Если SelectedIndex присвоено значение
            if let index = self.delegate?.shouldSelectObject() {
                self.selectionIndex = index
            }
            // Проверка, находится ли selectionIndex в границах массива slices
            if (self.selectionIndex >= 0 && self.selectionIndex < slicesCount ) {
                self.performSelection() // выполняем Выбор
            }
            else {
                let error = FortuneWheelError.init(message: "Invalid selection index", code: 0)
                self.performFinish(error: error)
            }
        }
        else {
            let error = FortuneWheelError.init(message: "No Slices", code: 0)
            self.performFinish(error: error)
        }
    }
    
    private func addWheelLayer() {
        //Проверка, существует ли массив секторов, если нет, то ошибка
        if let slices = self.slices {
            // Проверка, есть ли в массиве хотя бы 2 сектора, если нет - ошибка
            if slices.count >= 2 {
                self.wheelView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
                self.sectorAngle = (2 * CGFloat.pi)/CGFloat(slices.count)
                for (index,slice) in slices.enumerated() {
                    let sector = FortuneWheelSlice.init(frame: self.wheelView.bounds,
                                                        startAngle: self.sectorAngle * CGFloat(index),
                                                        sectorAngle: self.sectorAngle, slice: slice)
                    sector.sliceIndex = CGFloat(index)
                    var sectorTextLayer = CATextLayer()
                    sectorTextLayer.frame = self.wheelView.bounds
                    sectorTextLayer.string = slice.text
                    sector.addSublayer(sectorTextLayer)
                    self.wheelView.layer.addSublayer(sector)
                    sector.setNeedsDisplay()
                }
            }
            else {
                let error = FortuneWheelError.init(message: "not enough slices. Should have atleast two slices", code: 0)
                self.performFinish(error: error)
            }
        }
        else {
            let error = FortuneWheelError.init(message: "no Slices", code: 0)
            self.performFinish(error: error)
        }
    }
}

extension FortuneWheel : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.performFinish(error: nil)
        }
        else {
            let error = FortuneWheelError.init(message: "Error perforing selection", code: 0)
            self.performFinish(error: error)
        }
    }
}
