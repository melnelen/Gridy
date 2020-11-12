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
        setupWhiteView()
        setupCloseButton()
        setupStartButton()
        setupInstructionsLabel()
    }
    
    // #MARK: - Setup Elements
    
    private func setupUserImageView() {
        self.userImageView.image = image
        self.userImageView.clipsToBounds = true
        self.userImageView.contentMode = .scaleAspectFill
    }
    
    private func setupWhiteView() {
        self.whiteView.clipsToBounds = true
        self.whiteView.alpha = 0.8
        self.whiteView.backgroundColor = UIColor(named: "GridyWhite")
    }
    
    private func setupCloseButton() {
        self.closeButton.setTitle("x", for: .normal)
        self.closeButton.setTitleColor(UIColor(named: "GridyGray"), for: .normal)
        self.closeButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.helveticaNeue,
            size: Constant.Font.Size.closeButtonLabel)
    }
    
    private func setupStartButton() {
        self.startButton.setTitle("Start", for: .normal)
        self.startButton.setTitleColor(UIColor.white, for: .normal)
        self.startButton.backgroundColor = UIColor(named: "GridyGrassGreen")
        self.startButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.timeBurner,
            size: Constant.Font.Size.startButtonLabel)
        self.startButton.layer.cornerRadius = Constant.Layout.cornerRadius.buttonRadius
        self.startButton.clipsToBounds = true
    }
    
    private func setupInstructionsLabel() {
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
