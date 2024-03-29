//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 24/07/2020.
//  Copyright © 2020 Alex Ivanova. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK: - Parameters

    var image: UIImage!
    var croppedImage: UIImage!
    var imagePieces: [UIImage]!
    var initialImageViewOffset = CGPoint()
    
    private var scale: CGFloat = 1
    private var rotation: CGFloat = 0
    private var translation: CGPoint = .zero

    //MARK: - Elements
    
    @IBOutlet weak var snapshotView: UIView!
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var whiteView: WhiteLayerView!
    @IBOutlet weak var gridFrameView: UIView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!

    //MARK: - Actions

    @IBAction func closeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startButtonTouchedDown(_ sender: Any) {
        let imageRectangle = CGRect(
            x: self.chosenImageView.frame.minX,
            y: self.chosenImageView.frame.minY,
            width: self.chosenImageView.frame.width,
            height: self.chosenImageView.frame.height)
        let snapshotRectangle = CGRect(
            x: self.snapshotView.frame.minX,
            y: self.snapshotView.frame.minY,
            width: self.snapshotView.frame.width,
            height:self.snapshotView.frame.height)
        if imageRectangle.contains(snapshotRectangle) {
            self.croppedImage = crop(image: image)
            self.imagePieces = cropIn(pieces: croppedImage)
        } else {
            let alertController = UIAlertController(
                title: "Oh, no! 😱",
                message: "Some puzzle pieces are not full!",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }

    //MARK: - Setup Elements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserImageView()
        setupCloseButton()
        setupStartButton()
        setupInstructionsLabel()
        configureGestures(view: self.chosenImageView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.whiteView.layoutIfNeeded()
        self.whiteView.gridFrame = self.gridFrameView.frame
    }
    
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
            size: Constant.Font.Size.giantLabel)
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

    //MARK: - Configure Gestures
    
    private func configureGestures(view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resetImage(_:)))
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool {
        // simultaneous gesture recognition will only be supported for chosenImageView
        if gestureRecognizer.view != chosenImageView {
            return false
        }

        // if one of the gestures is a tap gesture do not recognise
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer
            || gestureRecognizer is UIPanGestureRecognizer
            || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }

        return true
    }

    //MARK: - Transform Image

    @objc func resetImage(_ sender: Any) {
        
        self.scale = 1
        self.rotation = 0
        self.translation = .zero
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.applyTransformations()
            },
            completion: nil
        )
    }
    
    @objc func moveImageView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.chosenImageView.superview)
        
        if sender.state == .began {
            initialImageViewOffset = self.translation
        }
        
        self.translation = CGPoint(
            x: initialImageViewOffset.x + translation.x,
            y: initialImageViewOffset.y + translation.y
        )
        self.applyTransformations()
        
    }
    
    @objc func rotateImageView(_ sender: UIRotationGestureRecognizer) {
        self.rotation += sender.rotation
        sender.rotation = 0
        self.applyTransformations()
    }
    
    @objc func scaleImageView(_ sender: UIPinchGestureRecognizer) {
        let minScale:CGFloat = 0.2
        let maxScale:CGFloat = 5
        let currentScale = self.scale
        
        switch sender.state {
        case .began, .changed:
            var newScale = currentScale * sender.scale
            if newScale < minScale {
                newScale = minScale
            } else if newScale > maxScale {
                newScale = maxScale
            }
            self.scale = newScale
            
            self.applyTransformations()
            
        case .ended:
            if !self.chosenImageView.frame.contains(self.gridFrameView.frame) {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.5,
                    options: [],
                    animations: {
                        self.applyTransformations()
                    }) { (success) in }
            }
        default:
            break
        }
        
        sender.scale = 1
    }
    
    private func applyTransformations() {
        self.chosenImageView.transform = CGAffineTransform.identity
            .translatedBy(x: self.translation.x, y: self.translation.y)
            .rotated(by: self.rotation)
            .scaledBy(x: self.scale, y: self.scale)
    }

    //MARK: - Crop Image
    
    private func crop(image: UIImage) -> UIImage {
        let rectangle = self.snapshotView.convert(self.gridFrameView.bounds, from: self.gridFrameView)
        let croppedImage = self.snapshotView.snapshot(of: rectangle, afterScreenUpdates: true)
        return croppedImage
    }
    
    private func cropIn(pieces image: UIImage) -> [UIImage] {
        let piecesHeight = image.size.height / 4
        let piecesWidth = image.size.width / 4
        
        var imagePieces: [UIImage] = []
        var rectangle: CGRect
        let scale: CGFloat = image.scale
        
        for column in 0..<4 {
            for line in 0..<4 {
                rectangle = CGRect(
                    x: CGFloat(line) * piecesWidth * scale,
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

    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let newVC: PuzzleViewController = segue.destination as! PuzzleViewController
            newVC.imageSizeView = self.gridFrameView
            newVC.originalImage = self.croppedImage
            newVC.originalImagePieces = self.imagePieces
            newVC.imageEditor = self
        }
    }
}

//MARK: - Extensions

private extension UIView {
    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated.
    ///   Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}
