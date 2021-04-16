//
//  FortuneWheel.swift
//  Wheel
//
//  Created by Татьяна Севостьянова on 16.04.2021.
//

import Foundation
import UIKit

class FortuneWheel : UIView {

    /**Size of the imageView which indcates which slice has been selected*/
    private lazy var indicatorSize : CGSize = {
    let size = CGSize.init(width: self.bounds.width * 0.126 , height: self.bounds.height * 0.126)
    return size }()

    /**The number slices the wheel has to be divided into is determined by this array count and
    each slice object contains its corresponding slices Data.*/
    private var slices : [Slice]?

    /**ImageView that holds an image which indicates which slice has been selected.*/
    private var indicator = UIImageView.init()

    /**Button which starts the spin game.This is places at the center of wheel.*/
    var playButton : UIButton = UIButton.init(type: .custom)

    
    typealias Radians = CGFloat
    /**Angle each slice occupies.*/
    private var sectorAngle : Radians = 0

    /**The view on which the slices will be drawn.This view will be roatated to simuate the spin.*/
    private var wheelView : UIView!

    /**Creates and returns an FortuneWheel with its center aligned to center CGPoint , diameter and slices drawn*/
    init(center: CGPoint, diameter : CGFloat , slices : [Slice])
    {
       super.init(frame: CGRect.init(origin: CGPoint.init(x: center.x - diameter/2, y: center.y - diameter/2), size: CGSize.init(width: diameter, height: diameter)))
       self.slices = slices
       self.initialSetUp()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /**The setup of the fortune wheel is done here.*/
    private func initialSetUp() {
        
        self.backgroundColor = .clear
        self.addWheelView()
        self.addStartBttn()
        self.addIndicator()
    }
    
    /**Adds the wheel view which has the slices.*/
    private func addWheelView()
    {
       
        let width = self.bounds.width - self.indicatorSize.width
        let height = self.bounds.height - self.indicatorSize.height
        
        /**Calculating x,y positions such that wheel view is aligned with FortuneWheel at the center*/
        let xPosition : CGFloat = (self.bounds.width/2) - (width/2)
        let yPosition : CGFloat = (self.bounds.height/2) - (height/2)
        
        self.wheelView = UIView.init(frame: CGRect.init(x: xPosition, y: yPosition, width: width, height: height))
        self.wheelView.backgroundColor = .gray
        self.wheelView.layer.cornerRadius = width/2
        self.wheelView.clipsToBounds = true
        self.addSubview(self.wheelView)
        
       
        //This functions will draw the slices.We will get to this later.
        self.addWheelLayer()
     }
    
    
    /**Adds selection Indicators*/
    private func addIndicator()
    {
      /**Calculating the position of the indicator such that half overlaps with the view and the rest if outsice of the view and
      locating indicator at the right side center of the wheel. i.e., at 0 degrees.*/
      let position = CGPoint.init(x: self.frame.width - self.indicatorSize.width, y: self.bounds.height/2 - self.indicatorSize.height/2)
      
      self.indicator.frame = CGRect.init(origin: position, size: self.indicatorSize)
      self.indicator.image = UIImage.init(named: "pointer")
      if self.indicator.superview == nil
       {
          self.addSubview(self.indicator)
       }
            
     }
    
    /**Adds spin or start game button to the view*/
    private func addStartBttn()
    {
       let size = CGSize.init(width: self.bounds.width * 0.15, height: self.bounds.height * 0.15)
       let point = CGPoint.init(x:  self.frame.width/2 - size.width/2, y: self.frame.height/2 - size.height/2)
       self.playButton.setTitle("Play", for: .normal)
       self.playButton.frame = CGRect.init(origin: point, size: size)
            
       //WE will add the StartAction method later on
       self.playButton.addTarget(self, action: #selector(startAction(sender:)), for: .touchUpInside)
       self.playButton.layer.cornerRadius = self.playButton.frame.height/2
       self.playButton.clipsToBounds = true
       self.playButton.backgroundColor = .gray
       self.playButton.layer.borderWidth = 0.5
       self.playButton.layer.borderColor = UIColor.white.cgColor
       self.addSubview(self.playButton)
    }
    
    @objc func startAction(sender: UIButton){

    }

    func performFinish(error : FortuneWheelError?){

    }
    
    private func addWheelLayer()
    {
       //We check if the slices array exists or not.if not we show an error.
       if let slices = self.slices
       {
          //We check if there are atleast 2 slices in the array.if not we show an error.
          if slices.count >= 2
          {
             self.wheelView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
                    
          //#1
             self.sectorAngle = (2 * CGFloat.pi)/CGFloat(slices.count)
                    
            // #2
             for (index,slice) in slices.enumerated()
             {
                //we will get to this class in a moment for now ignore the errors
                let sector = FortuneWheelSlice.init(frame: self.wheelView.bounds, startAngle: self.sectorAngle * CGFloat(index), sectorAngle: self.sectorAngle, slice: slice)
                self.wheelView.layer.addSublayer(sector)
                sector.setNeedsDisplay()
             }
          }
          else
          {
            let error = FortuneWheelError.init(message: "not enough slices. Should have atleast two slices", code: 0)
           // #3
            self.performFinish(error: error)
          }
       }
       else
       {
           let error = FortuneWheelError.init(message: "no Slices", code: 0)
         //  #3
           self.performFinish(error: error)
       }
    }


}
