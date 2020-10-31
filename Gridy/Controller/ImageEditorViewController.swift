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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        // #MARK: - Constraints
        
        self.userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.userImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.userImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.whiteView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.whiteView.translatesAutoresizingMaskIntoConstraints = false
        
        // #MARK: - Image
        
        self.userImageView.image = image
        self.userImageView.clipsToBounds = true
        self.userImageView.contentMode = .scaleAspectFill
        
        self.whiteView.clipsToBounds = true
        self.whiteView.alpha = 0.8
        self.whiteView.backgroundColor = UIColor.white
    }
}
