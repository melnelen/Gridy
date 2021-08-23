//
//  GridView.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 23/08/2021.
//  Copyright © 2021 Alex Ivanova. All rights reserved.
//

import UIKit

class GridView: UIView {
    let splitCount = 4

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 1.5
        path.fill(with: .color, alpha: 0.8)
        UIColor(named: Constant.Color.secondaryLight)!.setStroke()
        
        for x in 0...splitCount {
            for y in 0...splitCount {
                if x != y, x == 0, y < splitCount {
                    path.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
                    path.addLine(to: getPoint(rect, x: CGFloat(splitCount), y: CGFloat(y)))
                    path.stroke()
                } else if x < splitCount, x != 0, y == 0 {
                    path.move(to: getPoint(rect, x: CGFloat(x), y: CGFloat(y)))
                    path.addLine(to: getPoint(rect, x: CGFloat(x), y: CGFloat(splitCount)))
                    path.stroke()
                }
            }
        }
    }
  private func getPoint(_ rect: CGRect, x: CGFloat, y: CGFloat) -> CGPoint {
    let width = rect.width / CGFloat(splitCount)
    let height = rect.height / CGFloat(splitCount)
    return CGPoint(x: width * x, y: height * y)
  }

}
