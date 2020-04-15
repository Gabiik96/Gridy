//
//  PlayFieldViewController.swift
//  Gridy
//
//  Created by Gabriel Balta on 01/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SAConfettiView

class PlayFieldViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    // MARK: - Global variables
    var pickedSquares = [UIImage]()
    var hintImage: UIImage!
    private var imageViewOrigin: CGPoint!
    private var timer: Timer?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var newGameBtn: RoundButton!
    @IBOutlet weak var shareBtn: RoundButton!
    @IBOutlet weak var bigSquaresStackView: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var hintBtnView: UIButton!
    @IBOutlet weak var hintAlphaBackgroundView: UIView!
    @IBOutlet var squaresCollection: [CustomImageView]!
    @IBOutlet var bigSquaresCollection: [CustomImageView]!
    
    private var sound = SoundManager()
    private var puzzle = Puzzle()
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        // Puzzle initiliazer
        puzzle = Puzzle(originalLocations: pickedSquares, pickedSquares: pickedSquares, squaresCollection: squaresCollection, bigSquaresCollection: bigSquaresCollection, speakerBtn: speakerBtn, newGameBtn: newGameBtn, shareBtn: shareBtn, bigSquaresStackView: bigSquaresStackView, movesLbl: movesLbl)
        
        puzzle.addSquareImageToSquareView(collection: squaresCollection)
        movesLbl.text = "0"
        hintImageView.image = hintImage
        puzzle.checkSquares()
        speakerBtnSetup(identifier: "speaker.slash.fill")
        if let buttonState = UserDefaults.standard.object(forKey: "speaker") as? Bool {
            if buttonState == true {
                speakerBtnSetup(identifier: "speaker.slash.fill")
            } else if buttonState == false {
                speakerBtnSetup(identifier: "speaker.2.fill")
            }
        }
        for view in squaresCollection {
            addPanGesture(view: view)
        }
        for view in bigSquaresCollection {
            addSwipe(view: view)
        }
    }
    
    // MARK: - IBActions
    @IBAction func hintBtnPressed(_ sender: Any) {
        hintAlphaBackgroundView.toggleVisibility(firstTransition: .transitionCurlUp, secondTransition: .transitionCurlDown)
        hintImageView.toggleVisibility(firstTransition: .transitionCurlUp, secondTransition: .transitionCurlDown)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hintAlphaBackgroundView.toggleVisibility(firstTransition: .transitionCurlUp, secondTransition: .transitionCurlDown)
            self.hintImageView.toggleVisibility(firstTransition: .transitionCurlUp, secondTransition: .transitionCurlDown)
        }
    }
    
    @IBAction func newGameBtnPressed(_ sender: Any) {
        puzzle.pickedSquares.removeAll()
        sound.stopPlayingSounds(timer: timer)
        if let nav = self.navigationController { nav.popViewController(animated: true) }
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        sound.stopPlayingSounds(timer: timer)
        displaySharingOptions()
    }
    
    @IBAction func speakerBtnPressed(_ sender: Any) {
        speakerBtn.toggleSpeakerImage()
    }
    
    
    //MARK: - Functions
    
    //MARK Small squares movement functionality
    func addPanGesture(view: UIImageView) {
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(moveSquareImage))
        view.gestureRecognizers = [panRecognizer]
    }
    
    @objc func moveSquareImage(_ sender: UIPanGestureRecognizer) {
        let pannedImageView = sender.view! as! UIImageView
        
        switch sender.state {
        case .began:
            imageViewOrigin = pannedImageView.frame.origin
        case .changed:
            moveViewWithPan(view: pannedImageView, sender: sender)
        case.ended:
            for view in bigSquaresCollection {
                let convertedPannedView = pannedImageView.convert(pannedImageView.bounds, to: self.view)
                let convertedView = view.convert(view.bounds, to: self.view)
                if convertedPannedView.intersects(convertedView) && pannedImageView.image != view.image {
                    swapImage(imageView: pannedImageView, imageView2: view)
                    addMoveToScore()
                }
            }
            if puzzle.checkSquares() == true {
                puzzleCompleted()
            }
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
            sound.playSound(sound.squareInSound, speakerBtn)
        default: break
        }
        pannedImageView.setNeedsUpdateConstraints()
    }
    
    func moveViewWithPan(view: UIImageView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        view.center = CGPoint(x: translation.x + view.center.x,
                              y: translation.y + view.center.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    //MARK Big squares movements functionality
    func addSwipe(view: UIImageView) {
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(swipeBigSquareImage))
        view.gestureRecognizers = [panRecognizer]
    }
    
    @objc func swipeBigSquareImage(_ sender: UIPanGestureRecognizer) {
        let pannedImageView = sender.view! as! UIImageView
        
        switch sender.state {
        case .began:
            imageViewOrigin = pannedImageView.frame.origin
            if pannedImageView.image == nil {
                break
            }
        case .changed:
            swipeImageUP(view: pannedImageView, sender: sender)
        case.ended:
            let convertedPannedView = pannedImageView.convert(pannedImageView.bounds, to: self.view)
            let convertedY = convertedPannedView.minY
            while pannedImageView.image != nil && convertedY < (self.view.bounds.height / 3) {
                for view in squaresCollection {
                    if view.image == nil {
                        swapImage(imageView: pannedImageView, imageView2: view)
                        addMoveToScore()
                    }
                }
            }
            puzzle.checkSquares()
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
            sound.playSound(sound.squareOutSound, speakerBtn)
        default: break
        }
        pannedImageView.setNeedsUpdateConstraints()
    }
    
    func swipeImageUP(view: UIImageView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        if translation.y < 0 {
            view.center =  CGPoint(x: view.center.x,
                                   y: translation.y + view.center.y)
            sender.setTranslation(CGPoint.zero, in: view.superview)
        }
    }
    
    //MARK Mutual movement functionality && others
    func returnViewToOrigin(view: UIImageView, location: CGPoint) {
        if view.image == nil {
            view.frame.origin = location
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                view.frame.origin = location})
        }
    }
    
    func swapImage(imageView: UIImageView, imageView2: UIImageView) {
        let image1 = imageView.image
        let image2 = imageView2.image
        UIView.animate(withDuration: 0.5, animations: {
            imageView2.image = image1
            imageView.image = image2
        })
    }
    
    func addMoveToScore() {
        var currentScore = Int(movesLbl.text!)!
        currentScore += 1
        movesLbl.text = String(currentScore)
    }
    
    func puzzleCompleted() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Star
        view.addSubview(confettiView)
        confettiView.startConfetti()
        view.bringSubviewToFront(newGameBtn)
        view.bringSubviewToFront(shareBtn)
        sound.soundWithTimer(interval: 6, sound: sound.clapSound, speakerBtn: speakerBtn)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
            self.shareBtn.shake()
            self.newGameBtn.shake()
        }
    }
    
    func displaySharingOptions() {
        // define content to share
        let note = "Took me \(String(movesLbl.text!)) to complete this! Can you beat me ?"
        let image = composePuzzleImage()
        let items = [image as Any, note as Any]
        
        // create activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
        
        // present the view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    func composePuzzleImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(bigSquaresStackView.bounds.size, false, 0)
        bigSquaresStackView.drawHierarchy(in: bigSquaresStackView.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    func speakerBtnSetup(identifier: String) {
        speakerBtn.setImage(UIImage(systemName: identifier), for: UIControl.State.normal)
        speakerBtn.restorationIdentifier = identifier
    }
}

//MARK: - Extensions

extension UIView {
    func toggleVisibility(firstTransition : UIView.AnimationOptions, secondTransition: UIView.AnimationOptions) {
        let isVisible = self.alpha == 1
        UIView.transition(with: self, duration: 0.5, options: (isVisible ? firstTransition : secondTransition), animations: {
            self.alpha = isVisible ? 0 : 1
        })
    }
}

extension UIButton {
    func toggleSpeakerImage() {
        if self.restorationIdentifier == "speaker.2.fill" {
            saveUserDefaults(identifier: "speaker.slash.fill", bool: true)
        } else {
            saveUserDefaults(identifier: "speaker.2.fill", bool: false)
        }
    }
    
    func saveUserDefaults(identifier: String, bool: Bool){
        self.setImage(UIImage(systemName: identifier), for: UIControl.State.normal)
        self.restorationIdentifier = identifier
        UserDefaults.standard.set(bool, forKey: "speaker")
        UserDefaults.standard.synchronize()
    }
}



