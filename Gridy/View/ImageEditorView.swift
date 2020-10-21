//
//  ImageEditorView.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 21/10/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class ImageEditorView: UIView {
    private var startButton: UIButton!
    private var instructionsLabel: UILabel!
    private var closeButton: UIButton!
    
    private var clearView: UIView!
    private var initialUIImageViewCenter: CGPoint?
    
    var imagesBound: [CGRect]!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage) {
      super.init(frame: .zero)
      self.clipsToBounds = true
      self.backgroundColor = UIColor.lightGray
      self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setup(parentView view: UIView) {
      view.backgroundColor = UIColor.white
      view.addSubview(self)
      let safeArea = view.safeAreaLayoutGuide
      self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
      self.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
      self.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
      self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    }
    
    func updateLayout() {
      initialUIImageViewCenter = nil
      setupLayer(view: clearView)
    }
    
    private func setupLayer(view: UIView) {
      let fadingOutAnimation = {
        view.alpha = 0.0
        self.startButton.alpha = 0.0
        self.instructionsLabel.alpha = 0.0
        self.closeButton.alpha = 0.0
      }
      
      UIView.animate(withDuration: 0.1, animations: fadingOutAnimation) {
        (done) in
        if done {
          view.layer.mask = self.createMaskLayer()
          
          let fadingInAnimation = {
            view.alpha = 1.0
            self.startButton.alpha = 1.0
            self.instructionsLabel.alpha = 1.0
            self.closeButton.alpha = 1.0
          }
          UIView.animate(withDuration: 0.75, animations: fadingInAnimation)
        }
      }
    }
    
    private func createMaskLayer() -> CAShapeLayer {
      guard let superView = self.superview else { return CAShapeLayer()}
      let path = CGMutablePath()
      path.addRect(CGRect(origin: .zero, size: superView.bounds.size))
      
      imagesBound = Position.init(parentView: self).getSquares()
      for square in imagesBound {
        path.addRect(square)
      }
      
      let maskLayer = CAShapeLayer()
      maskLayer.path = path
      maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
      
      return maskLayer
    }
}
