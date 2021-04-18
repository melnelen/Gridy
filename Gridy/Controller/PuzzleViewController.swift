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
    var origin: CGRect!
    var initialImageViewOffset = CGPoint()
    var translation: CGPoint = .zero
    
    @IBOutlet var puzzlePiecesImageViews: [UIImageView]!
    @IBOutlet var puzzlePiecesPlaceholdersViews: [UIView]!
    @IBOutlet var puzzleBlocksViews: [UIView]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var soundImageView: UIImageView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var movesNimberLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNewGameButton()
        setupPuzzlePiecesImageViews()
        configureGestures(view: self.puzzlePiecesImageViews[0]) //I don't know how to configure gestures for an array of elements :(
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
    
    private func setupPuzzlePiecesImageViews() {
        let randomizedImagePieces = imagePieces.shuffled()
        
        //I want to apply to the puzzle pieces the same frames as the pieces placeholders
        for puzzlePiece in puzzlePiecesImageViews {
            for puzzlePiecePlaceholder in puzzlePiecesPlaceholdersViews {
                puzzlePiece.frame = puzzlePiecePlaceholder.frame
            }
        }
        
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            //fill puzzle pieces with images
            puzzlePiece.image = randomizedImagePieces[index]
        }
    }
    
    private func setupPuzzlePiecesPlaceholdersViews() {
        for puzzlePiecePlaceholder in puzzlePiecesPlaceholdersViews {
            //setup image views borders
            puzzlePiecePlaceholder.layer.borderColor = UIColor(named: Constant.Color.primaryLight)?.cgColor
            puzzlePiecePlaceholder.layer.masksToBounds = true
            puzzlePiecePlaceholder.contentMode = .scaleToFill
            puzzlePiecePlaceholder.layer.borderWidth = 1
        }
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func configureGestures(view: UIView) {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectPuzzlePieceImageView(_:)))
        longPressGestureRecognizer.delegate = self
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(movePuzzlePieceImageView(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func selectPuzzlePieceImageView(_ sender: UILongPressGestureRecognizer) {
        origin = view.frame
    }
    
    @objc func movePuzzlePieceImageView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.state == .began {
            initialImageViewOffset = self.translation
        }
        
        if sender.state == .changed {
            self.translation = CGPoint(
                x: initialImageViewOffset.x + translation.x,
                y: initialImageViewOffset.y + translation.y
            )
        }
        
        if sender.state == .ended {
            if !self.view.frame.contains(self.view.frame) {
                view.frame = origin
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool {
        // simultaneous gesture recognition will only be supported for a puzzlePiece
        for puzzlePiece in puzzlePiecesImageViews {
            if gestureRecognizer.view != puzzlePiece {
                return false
            }
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
    
}
