//
//  GridOverlay.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 29/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class whiteView: UIView {
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
        
        //Draw a rectangle
        let drawRectangle = CGRect(
            x: (width * 0.1),
            y: (height * 0.3),
            width: (width * 0.8),
            height: (width * 0.8)
        )
        
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
