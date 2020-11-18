//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 24/07/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate {
    var image: UIImage!
    var initialImageViewOffset = CGPoint()
    
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var whiteView: WhiteLayerView!
    @IBOutlet weak var gridFrameView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBAction func closeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserImageView()
        setupCloseButton()
        setupStartButton()
        setupInstructionsLabel()
        configureGestures()
    }
    
    // #MARK: - Setup Elements
    
    private func setupUserImageView() {
        self.chosenImageView.image = image
        self.chosenImageView.clipsToBounds = true
        self.chosenImageView.contentMode = .scaleAspectFill
    }
    
    private func setupCloseButton() {
        self.closeButton.setTitle("x", for: .normal)
        self.closeButton.setTitleColor(UIColor(named: Constant.Color.primaryDark), for: .normal)
        self.closeButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.primary,
            size: Constant.Font.Size.closeButton)
    }
    
    private func setupStartButton() {
        self.startButton.setTitle("Start", for: .normal)
        self.startButton.setTitleColor(UIColor (named: Constant.Color.secondaryLight), for: .normal)
        self.startButton.backgroundColor = UIColor(named: Constant.Color.primaryColor)
        self.startButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.secondary,
            size: Constant.Font.Size.primaryButton)
        self.startButton.layer.cornerRadius = Constant.Layout.cornerRadius.buttonRadius
        self.startButton.clipsToBounds = true
    }
    
    private func setupInstructionsLabel() {
        self.instructionsLabel.text = "Adjust the puzzle image:\nzoom, rotate, reposition"
        self.instructionsLabel.textColor = UIColor(named: Constant.Color.primaryDark)
        self.instructionsLabel.textAlignment = .center
        self.instructionsLabel.baselineAdjustment = .alignCenters
        self.instructionsLabel.numberOfLines = 0
        self.instructionsLabel.font = UIFont(
            name: Constant.Font.Name.secondary,
            size: Constant.Font.Size.primaryLabel)
    }
    
    func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rescaleImage(_:)))
        tapGestureRecognizer.delegate = self
        self.chosenImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        panGestureRecognizer.delegate = self
        self.chosenImageView.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        rotationGestureRecognizer.delegate = self
        self.chosenImageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        pinchGestureRecognizer.delegate = self
        self.chosenImageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func rescaleImage(_ sender: Any) {
        print("rescaling image")
        self.chosenImageView.transform = .identity
    }
    
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        print("moving")
        let translation = sender.translation(in: self.chosenImageView.superview)
        
        if sender.state == .began {
            initialImageViewOffset = self.chosenImageView.frame.origin
        }
        
        let position = CGPoint(
            x: translation.x + initialImageViewOffset.x - self.chosenImageView.frame.origin.x,
            y: translation.y + initialImageViewOffset.y - self.chosenImageView.frame.origin.y)
        
        self.chosenImageView.transform = self.chosenImageView.transform.translatedBy(x: position.x, y: position.y)
    }
    
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        print("rotating")
        self.chosenImageView.transform = self.chosenImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        print("scaling")
        self.chosenImageView.transform = self.chosenImageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            // simultaneous gesture recognition will only be supported for chosenImageView
            if gestureRecognizer.view != chosenImageView {
                return false
            }
            
            // neither of the recognized gestures should not be tap gesture
            if gestureRecognizer is UITapGestureRecognizer
                || otherGestureRecognizer is UITapGestureRecognizer
                || gestureRecognizer is UIPanGestureRecognizer
                || otherGestureRecognizer is UIPanGestureRecognizer {
                return false
            }
            
            return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.whiteView.layoutIfNeeded()
        self.whiteView.gridFrame = self.gridFrameView.frame
    }
}
