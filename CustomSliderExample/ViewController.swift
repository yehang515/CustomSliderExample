//
//  ViewController.swift
//  CustomSliderExample
//
//  Created by kyle on 16/6/1.
//  Copyright © 2016年 com.custom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // rangeSlider.backgroundColor = UIColor.redColor()
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(ViewController.rangeSliderValueChanged(_:)), forControlEvents: .ValueChanged)


    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: 31.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }


}

