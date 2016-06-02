//
//  RangeSlider.swift
//  CustomSliderExample
//
//  Created by kyle on 16/6/1.
//  Copyright © 2016年 com.custom. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    var minimumValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: Double = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    var trackTintColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighlightTintColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0)
    var thumbTintColor = UIColor.whiteColor()
    
    var curvaceousness : CGFloat = 1.0
    
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var previousLocation = CGPoint()

    let trackLayer = RangeSliderTrackLayer()

    var thumbWidth: CGFloat{
        return CGFloat(bounds.height)
    }
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)

        
        updateLayerFrames()
        
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func updateLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        CATransaction.commit()

    }
    
    func positionForValue(value: Double) -> Double {
        //let widthDouble = Double(thumbWidth)
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
         
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent!) -> Bool {
        previousLocation = touch.locationInView(self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
   
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent!) -> Bool {
        let location = touch.locationInView(self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
//        3. Update the UI
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        
//        updateLayerFrames()
//        
//        CATransaction.commit()
        
        return true
    }
    override func endTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
}
