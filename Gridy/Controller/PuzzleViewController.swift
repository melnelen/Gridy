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
        self.puzzlePiecesImageViews.forEach { puzzlePiece in
            configureGestures(view: puzzlePiece)
        }
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
        
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            //fill puzzle pieces with images
            puzzlePiece.frame = puzzlePiece.convert(puzzlePiecesPlaceholdersViews[index].bounds, from: puzzlePiecesPlaceholdersViews[index])
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
        
        view.isUserInteractionEnabled = true
    }
    
    @objc func selectPuzzlePieceImageView(_ sender: UILongPressGestureRecognizer) {
        origin = sender.view?.frame
        sender.view?.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
        print(sender.view)
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
        
        if sender.state == .cancelled {
            
        }
        
        if sender.state == .ended {
            if !self.view.frame.contains(self.view.frame) {
                sender.view?.frame = origin
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
