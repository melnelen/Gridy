//
//  PuzzleViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 23/03/2021.
//  Copyright © 2021 Alex Ivanova. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var imagePieces: [UIImage]!
    var imageEditor: ImageEditorViewController!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet var puzzlePiecesImageViews: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewGameButton()
        setupPuzzlePiecesImageViews()
    }
    
    private func setupNewGameButton() {
        self.newGameButton.setTitle("New game", for: .normal)
        self.newGameButton.setTitleColor(UIColor (named: Constant.Color.secondaryLight), for: .normal)
        self.newGameButton.backgroundColor = UIColor(named: Constant.Color.primaryColor)
        self.newGameButton.titleLabel?.font = UIFont(
            name: Constant.Font.Name.secondary,
            size: Constant.Font.Size.mediumButton)
        self.newGameButton.layer.cornerRadius = Constant.Layout.cornerRadius.buttonRadius
        self.newGameButton.clipsToBounds = true
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupPuzzlePiecesImageViews() {
        let randomizedImagePieces = imagePieces.shuffled()
        
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            //setup image views borders
            puzzlePiece.layer.borderColor = UIColor(named: Constant.Color.primaryLight)?.cgColor
            puzzlePiece.layer.masksToBounds = true
            puzzlePiece.contentMode = .scaleToFill
            puzzlePiece.layer.borderWidth = 1
            //fill puzzle pieces with images
            puzzlePiece.image = randomizedImagePieces[index]
        }
    }
    
}
