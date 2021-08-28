//
//  PuzzleViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 23/03/2021.
//  Copyright © 2021 Alex Ivanova. All rights reserved.
//

import UIKit

class PuzzleViewController: UIViewController, UIGestureRecognizerDelegate {

    var originalImage: UIImage!
    var originalImagePieces: [UIImage]!
    var imageEditor: ImageEditorViewController!
    private var origin: CGRect!
    private var initialImageViewOffset = CGPoint()
    private var translation: CGPoint = .zero
    private var score = 0
    
    @IBOutlet var puzzlePiecesImageViews: [UIImageView]!
    @IBOutlet var puzzlePiecesPlaceholdersViews: [UIView]!
    @IBOutlet var puzzleBlocksViews: [UIView]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var soundImageView: UIImageView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var movesCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNewGameButton()
        self.setupMovesCountLabel()
        self.setupPuzzlePiecesImageViews()
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

    private func setupMovesCountLabel() {
        self.movesCountLabel.font = UIFont(
            name: Constant.Font.Name.primary,
            size: Constant.Font.Size.giantLabel)
        self.movesCountLabel.textColor = UIColor (named: Constant.Color.primaryDark)
        self.movesCountLabel.text = String(score)
    }

    private func updateMovesCountLabel() {
        self.score += 1
        self.movesCountLabel.text = String(score)
    }
    
    private func setupPuzzlePiecesImageViews() {
        let randomizedImagePieces = originalImagePieces.shuffled()
        
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            puzzlePiece.translatesAutoresizingMaskIntoConstraints = true
            puzzlePiece.image = randomizedImagePieces[index]
            puzzlePiece.tag = index + 1
        }
    }
    
    private func updatePuzzlePiecesImageViews() {
        for (index, puzzlePiece) in puzzlePiecesImageViews.enumerated() {
            if (puzzlePiece.tag >= 1 && puzzlePiece.tag <= 16) {
                puzzlePiece.frame = self.view.convert(puzzlePiecesPlaceholdersViews[puzzlePiece.tag - 1].bounds,
                                                      from: puzzlePiecesPlaceholdersViews[puzzlePiece.tag - 1])
            } else if (puzzlePiece.tag >= 17 && puzzlePiece.tag <= 33) {
                puzzlePiece.frame = self.view.convert(puzzleBlocksViews[puzzlePiece.tag - 17].bounds,
                                                      from: puzzleBlocksViews[puzzlePiece.tag - 17])
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

    private func configureGestures(view: UIView) {
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
            for puzzlePiece in puzzlePiecesImageViews {
                if self.view.convert(puzzlePiece.bounds, from: puzzlePiece).contains(location)
                    && sender.view?.tag != puzzlePiece.tag {
                    sender.view?.frame = origin
                    return
                }
            }
            for (index, puzzlePiecePlaceholder) in puzzlePiecesPlaceholdersViews.enumerated() {
                if self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder).contains(location) {
                    sender.view?.frame = self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder)
                    sender.view?.tag = index + 1
                    updateMovesCountLabel()
                    return
                }
            }
            for (index, puzzleBlock) in puzzleBlocksViews.enumerated() {
                if self.view.convert(puzzleBlock.bounds, from: puzzleBlock).contains(location) {
                    sender.view?.frame = self.view.convert(puzzleBlock.bounds, from: puzzleBlock)
                    sender.view?.tag = index + 17
                    updateMovesCountLabel()
                    if checkSuccessCondition() {
                        print("Success!")
                        successfullyCompletedPuzzle()
                    }
                    return
                }
            }
            sender.view?.frame = origin
        }
    }

    private func checkSuccessCondition() -> Bool{
        for puzzlePiece in puzzlePiecesImageViews {
            guard (puzzlePiece.tag >= 17 && puzzlePiece.tag <= 33) else {
                return false
            }
            let indexInPuzzleContainer = puzzlePiece.tag - 17
            let expectedImage = originalImagePieces[indexInPuzzleContainer]

            if puzzlePiece.image != expectedImage {
                return false
            } else {
                continue
            }
        }
        return true
    }

    private func successfullyCompletedPuzzle() {
        let alertController = UIAlertController(title: "Hooray! 🎉🎉🎉",
                                                message: "Congratulations! You have successfully completed this puzzle! Your score is: \(score)",
            preferredStyle: .alert)

        let shareAction = UIAlertAction(title: "Share", style: .default) {
            (action) in
            self.showSharingOptions()
        }
        alertController.addAction(shareAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func showSharingOptions() {
        let note = "My score is: \(score). Can you do better?"
        let image = originalImage
        let items = [image as Any, note as Any]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash

        present(activityViewController, animated: true, completion: nil)
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
