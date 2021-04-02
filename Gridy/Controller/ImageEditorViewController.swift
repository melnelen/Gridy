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
    var croppedImage: UIImage!
    var imagePieces: [UIImage]!
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
    
    @IBAction func startButtonTouchedDown(_ sender: Any) {
        self.croppedImage = crop(image: image)
        self.imagePieces = cropIn(pieces: croppedImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserImageView()
        setupCloseButton()
        setupStartButton()
        setupInstructionsLabel()
        configureGestures(view: self.chosenImageView)
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
    
    func configureGestures(view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rescaleImage(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveImageView(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateImageView(_:)))
        rotationGestureRecognizer.delegate = self
        view.addGestureRecognizer(rotationGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleImageView(_:)))
        pinchGestureRecognizer.delegate = self
        view.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func rescaleImage(_ sender: Any) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.chosenImageView.transform = .identity
            }) { (success) in }
    }
    
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
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
        self.chosenImageView.transform = self.chosenImageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        let minScale:CGFloat = 0.5
        let maxScale:CGFloat = 5
        let currentScale = self.chosenImageView.frame.width/self.chosenImageView.bounds.size.width
        
        switch sender.state {
        case .began, .changed:
            var newScale = sender.scale
            if currentScale * sender.scale < minScale {
                newScale = minScale / currentScale
            } else if currentScale * sender.scale > maxScale {
                newScale = maxScale / currentScale
            }
            self.chosenImageView.transform = self.chosenImageView.transform.scaledBy(x: newScale, y: newScale)
            
        case .ended:
            print(gridFrameView.frame)
            print(chosenImageView.frame)
            print(self.view.convert(gridFrameView.bounds, from: gridFrameView))
            if !self.chosenImageView.frame.contains(self.gridFrameView.frame) {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.5,
                    options: [],
                    animations: {
                        self.chosenImageView.transform = .identity
                    }) { (success) in }
            }
        default:
            break
        }
        
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
    
    private func crop(image: UIImage) -> UIImage {
        let scale: CGFloat = image.scale
        let rectangle = self.chosenImageView.convert(self.gridFrameView.bounds, from: self.gridFrameView)
        let scaledRectangle = CGRect(x: rectangle.origin.x * scale,
                                     y: rectangle.origin.y * scale,
                                     width: rectangle.size.width * scale,
                                     height: rectangle.size.height * scale)
        let cgImage = image.cgImage!.cropping (to: scaledRectangle)
        let croppedImage = UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
        return croppedImage
    }
    
    private func cropIn(pieces image: UIImage) -> [UIImage] {
        let piecesHeight = image.size.height / 4
        let piecesWidth = image.size.width / 4
        
        var imagePieces: [UIImage] = []
        var rectangle: CGRect
        let scale: CGFloat = image.scale
        
        for line in 0..<4 {
            for column in 0..<4 {
                rectangle = CGRect(x: CGFloat(line) * piecesWidth * scale,
                                   y: CGFloat(column) * piecesHeight * scale,
                                   width: piecesWidth  * scale,
                                   height: piecesHeight  * scale)
                let cgImage = image.cgImage!.cropping (to: rectangle)
                let croppedImage = UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
                imagePieces.append(croppedImage)
            }
        }
        
        return imagePieces
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.whiteView.layoutIfNeeded()
        self.whiteView.gridFrame = self.gridFrameView.frame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let newVC: PuzzleViewController = segue.destination as! PuzzleViewController
            newVC.imagePieces = self.imagePieces
            newVC.imageEditor = self
        }
    }
}
