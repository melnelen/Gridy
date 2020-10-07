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
    
    @IBOutlet weak var ImageManipulationScrollView: UIScrollView!
    @IBOutlet weak var UserImageImageView: UIImageView!
    @IBOutlet weak var CloseButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var InstructionsLabel: UILabel!
    @IBOutlet weak var gridImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageViewConstraint = self.UserImageImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        imageViewConstraint.isActive = true
        self.UserImageImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.UserImageImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.UserImageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.UserImageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.ImageManipulationScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.ImageManipulationScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.ImageManipulationScrollView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.ImageManipulationScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.ImageManipulationScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.ImageManipulationScrollView.clipsToBounds = false
        self.ImageManipulationScrollView.minimumZoomScale = 0
        self.ImageManipulationScrollView.maximumZoomScale = 2
        self.ImageManipulationScrollView.delegate = self
        
        self.gridImage.topAnchor.constraint(equalTo: ImageManipulationScrollView.topAnchor, constant: 0).isActive = true
        self.gridImage.bottomAnchor.constraint(equalTo: ImageManipulationScrollView.bottomAnchor, constant: 0).isActive = true
        self.gridImage.leadingAnchor.constraint(equalTo: ImageManipulationScrollView.leadingAnchor, constant: 0).isActive = true
        self.gridImage.trailingAnchor.constraint(equalTo: ImageManipulationScrollView.trailingAnchor, constant: 0).isActive = true
    
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.UserImageImageView
    }
}
