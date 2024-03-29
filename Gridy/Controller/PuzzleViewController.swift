//
//  PuzzleViewController.swift
//  Gridy
//
//  Created by Alexandra Ivanova on 23/03/2021.
//  Copyright © 2021 Alex Ivanova. All rights reserved.
//

import UIKit
import AVFoundation

class PuzzleViewController: UIViewController, UIGestureRecognizerDelegate, AVAudioPlayerDelegate {

    //MARK: - Parameters

    var originalImage: UIImage!
    var originalImagePieces: [UIImage]!
    var imageSizeView: UIView!
    var imageEditor: ImageEditorViewController!

    private var origin: CGRect!
    private var initialImageViewOffset = CGPoint()
    private var translation: CGPoint = .zero
    private var score = 0
    private var audioPlayer: AVAudioPlayer!

    //MARK: - Elements

    @IBOutlet var puzzlePiecesImageViews: [UIImageView]!
    @IBOutlet var puzzlePiecesPlaceholdersViews: [UIView]!
    @IBOutlet var puzzleBlocksViews: [UIView]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var movesCountLabel: UILabel!

    //MARK: - Actions

    @IBAction func startNewGame(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func changeSoundOption(_ sender: Any) {
        if self.soundButton.currentImage == UIImage(named: Constant.Icon.muteSound) {
            self.soundButton.setImage(UIImage(named: Constant.Icon.onSound), for: .normal)
        } else {
            self.soundButton.setImage(UIImage(named: Constant.Icon.muteSound), for: .normal)
        }
    }

    @IBAction func showHintImage(_ sender: Any) {
        let alert = UIAlertController(title: "",
                                      message: nil,
                                      preferredStyle: .alert)

        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: imageSizeView.frame.size.width,
            height: imageSizeView.frame.size.height))
        imageView.image = originalImage

        alert.view.addSubview(imageView)

        let constraintWidth = NSLayoutConstraint(
            item: alert.view!,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: CGFloat(imageView.frame.width))
        let constraintHeight = NSLayoutConstraint(
            item: alert.view!,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: CGFloat(imageView.frame.height))
        for constraint in alert.view.constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.width
                && constraint.constant == CGFloat(imageView.frame.width) {
                NSLayoutConstraint.deactivate([constraint])
                break
            }
        }
        alert.view.addConstraint(constraintWidth)
        alert.view.addConstraint(constraintHeight)

        alert.popoverPresentationController?.sourceView = view // so it won't crash on iPad

        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard self?.presentedViewController == alert else { return }
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    //MARK: - Setup Elements

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNewGameButton()
        self.setupMovesCountLabel()
        self.setupSoundButton()
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
            puzzlePiece.contentMode = .scaleAspectFill
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

    private func setupSoundButton() {
        self.soundButton.setImage(UIImage(named: Constant.Icon.muteSound), for: .normal)
    }

    //MARK: - Configure Gestures

    private func configureGestures(view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPuzzlePieceImageView(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(movePuzzlePieceImageView(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)

        view.isUserInteractionEnabled = true
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

            // if one of the gestures is a tap gesture do not recognise
            if gestureRecognizer is UITapGestureRecognizer
                || otherGestureRecognizer is UITapGestureRecognizer
                || gestureRecognizer is UIPanGestureRecognizer
                || otherGestureRecognizer is UIPanGestureRecognizer {
                return false
            }

            return true
    }

    //MARK: - Move Puzzle Pieces

    @objc func selectPuzzlePieceImageView(_ sender: UILongPressGestureRecognizer) {
        origin = sender.view?.frame
    }

    @objc func movePuzzlePieceImageView(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let pickupSound = URL(fileURLWithPath: Bundle.main.path(forResource: "pickup-click", ofType: "wav")!)
        let dropSound = URL(fileURLWithPath: Bundle.main.path(forResource: "drop-click", ofType: "wav")!)
        let errorSound = URL(fileURLWithPath: Bundle.main.path(forResource: "error", ofType: "wav")!)
        let applauseSound = URL(fileURLWithPath: Bundle.main.path(forResource: "applause", ofType: "wav")!)

        if sender.state == .began {
            origin = sender.view?.frame
            self.view.bringSubviewToFront(sender.view!)
            if soundIsOn() {
                makeASound(sound: pickupSound)
            }
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
            if soundIsOn() {
                makeASound(sound: errorSound)
            }
        }

        if sender.state == .ended {
            for puzzlePiece in puzzlePiecesImageViews {
                if self.view.convert(puzzlePiece.bounds, from: puzzlePiece).contains(location)
                    && sender.view?.tag != puzzlePiece.tag {
                    sender.view?.frame = origin
                    if soundIsOn() {
                        makeASound(sound: errorSound)
                    }
                    return
                }
            }
            for (index, puzzlePiecePlaceholder) in puzzlePiecesPlaceholdersViews.enumerated() {
                if self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder).contains(location) {
                    sender.view?.frame = self.view.convert(puzzlePiecePlaceholder.bounds, from: puzzlePiecePlaceholder)
                    sender.view?.tag = index + 1
                    updateMovesCountLabel()
                    if soundIsOn() {
                        makeASound(sound: dropSound)
                    }
                    return
                }
            }
            for (index, puzzleBlock) in puzzleBlocksViews.enumerated() {
                if self.view.convert(puzzleBlock.bounds, from: puzzleBlock).contains(location) {
                    sender.view?.frame = self.view.convert(puzzleBlock.bounds, from: puzzleBlock)
                    sender.view?.tag = index + 17
                    updateMovesCountLabel()
                    if soundIsOn() {
                        makeASound(sound: dropSound)
                    }
                    if checkSuccessCondition() {
                        successfullyCompletedPuzzle()
                        if soundIsOn() {
                            makeASound(sound: applauseSound)
                        }
                    }
                    return
                }
            }
            sender.view?.frame = origin
            if soundIsOn() {
                makeASound(sound: errorSound)
            }
        }
    }

    private func soundIsOn() -> Bool {
        return self.soundButton.currentImage == UIImage(named: Constant.Icon.onSound) ? true : false
    }

    private func makeASound(sound: URL) {
        if self.soundButton.currentImage == UIImage(named: Constant.Icon.onSound) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: sound)
            } catch _{
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }

    //MARK: - Complete Puzzle

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
        let alertController = UIAlertController(
            title: "Hooray! 🎉🎉🎉",
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
}
