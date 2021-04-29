//
//  FortuneWheel.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import UIKit


public class FortuneWheel: UIControl, CAAnimationDelegate, SpinningAnimatorProtocol {
    
    // Установите true, если вы хотите, чтобы все сектора распределялись равномерно
    open var equalSlices: Bool = false
    open var slices: [SpinningWheelSliceProtocol]!
    
    // Настройки основного фрейма
    open var frameStroke: StrokeInfo = StrokeInfo(color: .borderWheel, width: 8)
    open var shadow: NSShadow?
    
    // Установите значение, чтобы начать рисовать с таким смешением
    // Центр первого сектора для этого смещения будет равен 0
    open var initialDrawingOffset: CGFloat = 0.0
    
    open var titleRotation: CGFloat = 0.0
    
    lazy private var animator: SpinningWheelAnimator = SpinningWheelAnimator(withObjectToAnimate: self)
    private(set) var sliceDegree: CGFloat?
    private(set) var wheelLayer: FortuneWheelLayer!
    
    public init(frame: CGRect, slices:[SpinningWheelSliceProtocol]) {
        super.init(frame: frame)
        self.slices = slices
        self.shadow = defaultShadow
        addWheelLayer()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layer.needsDisplayOnBoundsChange = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.shadow = defaultShadow
    }
    
    func sliceInfoIsValid() -> Bool {
        if equalSlices{ return true }
        return slices.reduce(0, {$0 + $1.degree}) == 360
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        if let existing = wheelLayer {
            existing.removeFromSuperlayer()
        }
        addWheelLayer()
        assert(sliceInfoIsValid(), "All slices must have a 360 degree combined. Set equalSlices true if you want to distribute them evenly.")
        if equalSlices {
            sliceDegree = 360.0 / CGFloat(slices.count)
        }
    }
    
    private func addWheelLayer() {
        wheelLayer = FortuneWheelLayer(frame: self.bounds, parent: self, initialOffset: initialDrawingOffset)
        self.layer.addSublayer(wheelLayer)
        wheelLayer.setNeedsDisplay()
    }
    
    internal var defaultShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.4)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 14
        return shadow
    }
    
    // Подписка анимации
    internal var layerToAnimate: CALayer {
        return self.wheelLayer
    }
    
//    open func startAnimating(rotationCompletionOffset: CGFloat = 0.0, _ completion:((Bool) -> Void)?) {
//        self.stopAnimating()
//        self.animator.addRotationAnimation(completionBlock: completion, rotationOffset: rotationCompletionOffset)
//    }
    
    open func startAnimating(fininshIndex: Int = 0, _ completion:((Bool) -> Void)?) {
//        let rotation = 360.0 - computeRadian(from: fininshIndex)
//        self.startAnimating(rotationCompletionOffset: rotation, completion)
    }
    
    open func startAnimating() {
    //    self.animator.addIndefiniteRotationAnimation()
        self.animator.addRotationAnimation()
    }
    
    open func stopAnimating() {
        self.animator.removeAllAnimations()
    }
    
    open func startAnimating(fininshIndex: Int = 0, offset: CGFloat, _ completion:((Bool) -> Void)?) {
//        let rotation = 360.0 - computeRadian(from: fininshIndex) + offset
//        self.startAnimating(rotationCompletionOffset: rotation, completion)
    }
    
    private func computeRadian(from finishIndex: Int) -> CGFloat {
        if equalSlices {
            return CGFloat(finishIndex) * sliceDegree!
        }
        return slices.enumerated().filter({ $0.offset < finishIndex}).reduce(0.0, { $0 + $1.element.degree })
    }
}
