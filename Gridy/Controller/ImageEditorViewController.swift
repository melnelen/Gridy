//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 24/07/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController, UIScrollViewDelegate {
    var image: UIImage!
    var imagesBound: [CGRect]!
    
    @IBOutlet weak var imageManipulationScrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var gridImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #MARK: - Constraints
        
        self.userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.userImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.userImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageManipulationScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.imageManipulationScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.imageManipulationScrollView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageManipulationScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageManipulationScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.gridImage.topAnchor.constraint(equalTo: imageManipulationScrollView.topAnchor, constant: 0).isActive = true
        self.gridImage.bottomAnchor.constraint(equalTo: imageManipulationScrollView.bottomAnchor, constant: 0).isActive = true
        self.gridImage.leadingAnchor.constraint(equalTo: imageManipulationScrollView.leadingAnchor, constant: 0).isActive = true
        self.gridImage.trailingAnchor.constraint(equalTo: imageManipulationScrollView.trailingAnchor, constant: 0).isActive = true
        
        // #MARK: - Image
        
        self.userImageView.image = image
        self.userImageView.clipsToBounds = true
        self.userImageView.backgroundColor = UIColor.lightGray
        self.userImageView.contentMode = .scaleAspectFill
        
        self.imageManipulationScrollView.clipsToBounds = false
        self.imageManipulationScrollView.minimumZoomScale = 0
        self.imageManipulationScrollView.maximumZoomScale = 3
        self.imageManipulationScrollView.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.userImageView
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
        let whiteView = UIView(frame: userImageView.bounds)
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: userImageView.bounds.size))
        
        imagesBound = Position.init(parentView: whiteView).getSquares()
        for square in imagesBound {
            path.addRect(square)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        return maskLayer
    }
}
