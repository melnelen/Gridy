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
        self.userImageView.contentMode = .scaleAspectFill
        
        self.imageManipulationScrollView.clipsToBounds = false
        self.imageManipulationScrollView.minimumZoomScale = 0
        self.imageManipulationScrollView.maximumZoomScale = 3
        self.imageManipulationScrollView.delegate = self
        
        self.whiteView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        self.whiteView.clipsToBounds = true
        
        let maskLayer = CAShapeLayer()

        let radius : CGFloat = userImageView.bounds.width/3
        let path = UIBezierPath(rect: userImageView.bounds)
        maskLayer.path = path.cgPath
        path.addArc(
            withCenter: userImageView.center,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat.pi*2,
            clockwise: true
        )
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.whiteView.layer.mask = maskLayer
        self.whiteView.clipsToBounds = true

        self.whiteView.alpha = 0.8
        self.whiteView.backgroundColor = UIColor.white
        
        view.addSubview(whiteView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.userImageView
    }
}
