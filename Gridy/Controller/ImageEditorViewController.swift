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
        
        self.closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        self.closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.startButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.startButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 0.05)).isActive = true
        self.startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1).isActive = true
        self.instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.instructionsLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.instructionsLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // #MARK: - Image
        
        self.userImageView.image = image
        self.userImageView.clipsToBounds = true
        self.userImageView.contentMode = .scaleAspectFill
        
        self.whiteView.clipsToBounds = true
        self.whiteView.alpha = 0.8
        self.whiteView.backgroundColor = UIColor(named: "GridyWhite")
        
        // #MARK: - Buttons
        
        self.closeButton.setTitle("x", for: .normal)
        self.closeButton.setTitleColor(UIColor(named: "GridyGray"), for: .normal)
        self.closeButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.helveticaNeue,
            size: Constant.Font.Size.closeButtonLabel)
        
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.backgroundColor = UIColor(named: "GridyGrassGreen")
        startButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.timeBurner,
            size: Constant.Font.Size.startButtonLabel)
        startButton.layer.cornerRadius = 10
        startButton.clipsToBounds = true
        
        // #MARK: - Label
        
        self.instructionsLabel.text = "Adjust the puzzle image:\nzoom, rotate, reposition"
        self.instructionsLabel.textColor = UIColor(named: "GridyGray")
        self.instructionsLabel.textAlignment = .center
        self.instructionsLabel.baselineAdjustment = .alignCenters
        self.instructionsLabel.numberOfLines = 0
        self.instructionsLabel.font = UIFont(
            name: Constant.Font.Name.timeBurner,
            size: Constant.Font.Size.instructionsLabel)
    }
}
