//
//  Utils.swift
//  FWheel
//
//  Created by Татьяна Севостьянова on 25.04.2021.
//

import Foundation
import UIKit


public class Utils {
    
    class func group(animations: [CAAnimation], fillMode: String!, forEffectLayer: Bool = false, sublayersCount: NSInteger = 0) -> CAAnimationGroup!{
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = animations
        
        if (fillMode != nil){
            if let animations = groupAnimation.animations {
                for anim in animations {
                    anim.fillMode = CAMediaTimingFillMode(rawValue: fillMode!)
                }
            }
            groupAnimation.fillMode = CAMediaTimingFillMode(rawValue: fillMode!)
            groupAnimation.isRemovedOnCompletion = false
        }
        
        if forEffectLayer {
            groupAnimation.duration = Utils.maxDuration(ofEffectAnimation: groupAnimation, sublayersCount: sublayersCount)
        } else {
            groupAnimation.duration = Utils.maxDuration(ofAnimations: animations)
        }
        return groupAnimation
    }
    
    class func maxDuration(ofAnimations anims: [CAAnimation]) -> CFTimeInterval{
        var maxDuration: CGFloat = 0;
        for anim in anims {
            maxDuration = max(CGFloat(anim.beginTime + anim.duration) * CGFloat(anim.repeatCount == 0 ? 1.0 : anim.repeatCount) * (anim.autoreverses ? 2.0 : 1.0), maxDuration);
        }
        
        if maxDuration.isInfinite {
            return TimeInterval(NSIntegerMax)
        }
        return CFTimeInterval(maxDuration);
    }
    
    class func maxDuration(ofEffectAnimation anim: CAAnimation, sublayersCount : NSInteger) -> CFTimeInterval{
        var maxDuration: CGFloat = 0
        if let groupAnim = anim as? CAAnimationGroup {
            for subAnim in groupAnim.animations! as [CAAnimation]{
                
                var delay: CGFloat = 0
                if let instDelay = (subAnim.value(forKey: "instanceDelay") as? NSNumber)?.floatValue{
                    delay = CGFloat(instDelay) * CGFloat(sublayersCount - 1)
                }
                var repeatCountDuration: CGFloat = 0
                if subAnim.repeatCount > 1 {
                    repeatCountDuration = CGFloat(subAnim.duration) * CGFloat(subAnim.repeatCount - 1)
                }
                var duration: CGFloat = 0
                
                duration = CGFloat(subAnim.beginTime) + (subAnim.autoreverses ? CGFloat(subAnim.duration) : CGFloat(0)) + delay + CGFloat(subAnim.duration) + CGFloat(repeatCountDuration)
                maxDuration = max(duration, maxDuration)
            }
        }
        
        if maxDuration.isInfinite {
            maxDuration = 1000
        }
        return CFTimeInterval(maxDuration);
    }
    
    class func updateValueFromAnimations(forLayers layers: [CALayer]) {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        for aLayer in layers {
            if let keys = aLayer.animationKeys() as [String]? {
                for animKey in keys {
                    let anim = aLayer.animation(forKey: animKey)
                    updateValue(forAnimation: anim!, theLayer: aLayer)
                }
            }
        }
        
        CATransaction.commit()
    }
    
    class func updateValue(forAnimation anim: CAAnimation, theLayer : CALayer) {
        if let basicAnim = anim as? CABasicAnimation{
            if (!basicAnim.autoreverses) {
                theLayer.setValue(basicAnim.toValue, forKeyPath: basicAnim.keyPath!)
            }
        } else if let keyAnim = anim as? CAKeyframeAnimation {
            if (!keyAnim.autoreverses) {
                theLayer.setValue(keyAnim.values?.last, forKeyPath: keyAnim.keyPath!)
            }
        } else if let groupAnim = anim as? CAAnimationGroup {
            for subAnim in groupAnim.animations! as [CAAnimation] {
                updateValue(forAnimation: subAnim, theLayer: theLayer)
            }
        }
    }
    
    class func updateValueFromPresentationLayer(forAnimation anim: CAAnimation!, theLayer : CALayer){
        if let basicAnim = anim as? CABasicAnimation {
            theLayer.setValue(theLayer.presentation()?.value(forKeyPath: basicAnim.keyPath!), forKeyPath: basicAnim.keyPath!)
        } else if let keyAnim = anim as? CAKeyframeAnimation {
            theLayer.setValue(theLayer.presentation()?.value(forKeyPath: keyAnim.keyPath!), forKeyPath: keyAnim.keyPath!)
        } else if let groupAnim = anim as? CAAnimationGroup {
            for subAnim in groupAnim.animations! as [CAAnimation] {
                updateValueFromPresentationLayer(forAnimation: subAnim, theLayer: theLayer)
            }
        }
    }
}

extension Collection where Indices.Iterator.Element == Index {
    
// Возвращает элемент с указанным индексом, если он находится в пределах границ, иначе пусто
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Bundle {
    public static func sw_frameworkBundle() -> Bundle {
        let bundle = Bundle(for: Utils.self)
        if let path = bundle.path(forResource: "FortuneWheel", ofType: "bundle") {
            return Bundle(path: path)!
        }
        else {
            return bundle
        }
    }
}
