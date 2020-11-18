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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.whiteView.layoutIfNeeded()
        self.whiteView.gridFrame = self.gridFrameView.frame
    }
}
