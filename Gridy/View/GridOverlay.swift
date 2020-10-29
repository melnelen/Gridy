//
//  GridOverlay.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 29/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class GridOverlay: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    private func setup() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        let radius: CGFloat = self.bounds.width/3
        let path = UIBezierPath(rect: self.bounds)
        path.addArc(
            withCenter: self.center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat.pi*2,
            clockwise: true
        )
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        self.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
    }
}
