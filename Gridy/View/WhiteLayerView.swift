//
//  GridOverlay.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 29/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class WhiteLayerView: UIView {
    var gridFrame: CGRect = .zero {
        didSet { setup() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.alpha = 0.8
        self.backgroundColor = UIColor(named: Constant.Color.secondaryLight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        //Create the mask layer
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        let rectangleLayer = CAShapeLayer()
        rectangleLayer.frame = self.bounds
        
        //Create a path with the rectangle in it
        let framePath = UIBezierPath(rect: self.bounds)
        let rectanglePath = UIBezierPath(rect: gridFrame)
        
        //Reverse the filled in area to be outside of the rectangle
        rectanglePath.append(framePath.reversing())
        
        //Give the mask layer the path that was just drawn
        rectangleLayer.path = rectanglePath.cgPath
        maskLayer.addSublayer(rectangleLayer)
        self.layer.mask = maskLayer
    }
}
