//
//  GridOverlay.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 29/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class WhiteLayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        let width = self.bounds.width
        let height = self.bounds.height
        var drawRectangle = CGRect()
        //Draw a rectangle
        if (height > width) {
            drawRectangle = CGRect(
                x: (width * 0.05),
                y: (height * 0.25),
                width: (width * 0.9),
                height: (width * 0.9))
        } else {
            drawRectangle = CGRect(
                x: (width * 0.05),
                y: (height * 0.05),
                width: (height * 0.9),
                height: (height * 0.9))
        }
        
        //Create a path with the rectangle in it
        let framePath = UIBezierPath(rect: self.bounds)
        let rectanglePath = UIBezierPath(rect: drawRectangle)
        
        //Reverse the filled in area to be outside of the rectangle
        rectanglePath.append(framePath.reversing())
        
        //Give the mask layer the path that was just drawn
        rectangleLayer.path = rectanglePath.cgPath
        maskLayer.addSublayer(rectangleLayer)
        self.layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
    }
}
