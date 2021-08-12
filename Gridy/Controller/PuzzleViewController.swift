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
    
    private var isDragging = false
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.updatePuzzlePiecesImageViews()
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
            puzzlePiece.translatesAutoresizingMaskIntoConstraints = true
            puzzlePiece.image = randomizedImagePieces[index]
        }
    }
    
    private func updatePuzzlePiecesImageViews() {
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            if (puzzlePiece.tag >= 1 && puzzlePiece.tag <= 16) {
                puzzlePiece.frame = self.view.convert(puzzleBlocksViews[puzzlePiece.tag - 1].bounds, from: puzzleBlocksViews[puzzlePiece.tag - 1])
            } else if (puzzlePiece.tag >= 17 && puzzlePiece.tag <= 33) {
                puzzlePiece.frame = self.view.convert(puzzlePiecesPlaceholdersViews[puzzlePiece.tag - 17].bounds, from: puzzlePiecesPlaceholdersViews[puzzlePiece.tag - 17])
            } else {
                puzzlePiece.frame = self.view.convert(puzzlePiecesPlaceholdersViews[index].bounds, from: puzzlePiecesPlaceholdersViews[index])
            }
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPuzzlePieceImageView(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(movePuzzlePieceImageView(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.isUserInteractionEnabled = true
    }
    
    @objc func selectPuzzlePieceImageView(_ sender: UILongPressGestureRecognizer) {
        origin = sender.view?.frame
    }
    
    @objc func movePuzzlePieceImageView(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        
        if sender.state == .began {
            origin = sender.view?.frame
            //            puzzlePeceState
        }
        
        if sender.state == .changed {
            sender.view?.frame = CGRect(x: location.x - (sender.view!.frame.width/2),
                                        y: location.y - (sender.view!.frame.height/2),
                                        width: sender.view!.frame.width,
                                        height: sender.view!.frame.height)
        }
        
        if sender.state == .cancelled {
            sender.view?.frame = origin
            sender.view?.tag = 0
        }
        
        if sender.state == .ended {
            for (index, puzzleBlock) in puzzleBlocksViews.enumerated() {
                if self.view.convert(puzzleBlock.bounds, from: puzzleBlock).contains(location) {
                    sender.view?.frame = self.view.convert(puzzleBlock.bounds, from: puzzleBlock)
                    sender.view?.tag = index + 1
                    break
                } else {
                    sender.view?.frame = origin
                }
            }
            for (index, puzzlePiecePlaceholder) in puzzlePiecesPlaceholdersViews.enumerated() {
                if self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder).contains(location) {
                    sender.view?.frame = self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder)
                    sender.view?.tag = index + 17
                    break
                } else {
                    sender.view?.frame = origin
                }
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
