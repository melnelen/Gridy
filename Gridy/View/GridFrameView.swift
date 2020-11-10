//
//  GridFrameView.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 08/11/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class GridFrameView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func getX() ->CGFloat {
        return self.frame.origin.x
    }
    
    static func getY() ->CGFloat {
        return self.frame.origin.y
    }
    
    func getWidth() ->CGFloat {
        return self.bounds.width
    }
    
    func getHeight() ->CGFloat {
        return self.bounds.height
    }
}
