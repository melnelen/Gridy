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
    @IBOutlet weak var userImageImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var gridImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImageImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.userImageImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.userImageImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.userImageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.userImageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageManipulationScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.imageManipulationScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.imageManipulationScrollView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageManipulationScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageManipulationScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageManipulationScrollView.clipsToBounds = false
        self.imageManipulationScrollView.minimumZoomScale = 0
        self.imageManipulationScrollView.maximumZoomScale = 2
        self.imageManipulationScrollView.delegate = self
        
        self.gridImage.topAnchor.constraint(equalTo: imageManipulationScrollView.topAnchor, constant: 0).isActive = true
        self.gridImage.bottomAnchor.constraint(equalTo: imageManipulationScrollView.bottomAnchor, constant: 0).isActive = true
        self.gridImage.leadingAnchor.constraint(equalTo: imageManipulationScrollView.leadingAnchor, constant: 0).isActive = true
        self.gridImage.trailingAnchor.constraint(equalTo: imageManipulationScrollView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.userImageImageView
    }
}
