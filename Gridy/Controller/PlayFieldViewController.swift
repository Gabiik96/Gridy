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
    var pickedTiles = [UIImage]()
    var hintImage: UIImage!
    private var imageViewOrigin: CGPoint!
    private var timer: Timer?
    
    // MARK: - Class references
    private var sound = SoundManager()
    private var puzzle = Puzzle()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var newGameBtn: RoundButton!
    @IBOutlet weak var shareBtn: RoundButton!
    @IBOutlet weak var bigTilesStackView: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var hintBtnView: UIButton!
    @IBOutlet weak var hintAlphaBackgroundView: UIView!
    @IBOutlet var smallTilesCollection: [CustomImageView]!
    @IBOutlet var bigTilesCollection: [CustomImageView]!
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        // Puzzle initiliazer
        puzzle = Puzzle(originalImages: pickedTiles,
                        pickedTiles: pickedTiles,
                        smallTilesCollection: smallTilesCollection,
                        bigTilesCollection: bigTilesCollection,
                        speakerBtn: speakerBtn,
                        newGameBtn: newGameBtn,
                        shareBtn: shareBtn,
                        movesLbl: movesLbl)
        puzzle.addSquareImageToSquareView(collection: smallTilesCollection)
        movesLbl.text = "0"
        hintImageView.image = hintImage
        puzzle.checkTiles()
        speakerBtnSetup(identifier: "speaker.slash.fill")
        if let buttonState = UserDefaults.standard.object(forKey: "speaker") as? Bool {
            if buttonState == true {
                speakerBtnSetup(identifier: "speaker.slash.fill")
            } else if buttonState == false {
                speakerBtnSetup(identifier: "speaker.2.fill")
            }
        }
        for view in smallTilesCollection {
            addPanGesture(view: view)
        }
        for view in bigTilesCollection {
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
        puzzle.pickedTiles.removeAll()
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
    
    //MARK Small tiles movement functionality
    func addPanGesture(view: UIImageView) {
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(moveSmallTile))
        view.gestureRecognizers = [panRecognizer]
    }
    
    @objc func moveSmallTile(_ sender: UIPanGestureRecognizer) {
        let pannedImageView = sender.view! as! UIImageView
        guard pannedImageView.image != nil else { return }
        
        switch sender.state {
        case .began:
            view.bringSubviewToFront(pannedImageView)
            imageViewOrigin = pannedImageView.frame.origin
        case .changed:
            moveViewWithPan(view: pannedImageView, sender: sender)
        case.ended:
            for view in bigTilesCollection.reversed() {
                let convertedPannedView = pannedImageView.convert(pannedImageView.bounds, to: self.view)
                let convertedView = view.convert(view.bounds, to: self.view)
                if convertedPannedView.intersects(convertedView) && pannedImageView.image != view.image {
                    swapImage(imageView: pannedImageView, imageView2: view)
                    addMoveToScore()
                    sound.playSound(sound.squareInSound, speakerBtn)
                    break
                }
            }
            if puzzle.checkTiles() == true {
                puzzleCompleted()
            }
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
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
    
    //MARK Big tiles movements functionality
    func addSwipe(view: UIImageView) {
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(swipeBigTile))
        view.gestureRecognizers = [panRecognizer]
    }
    
    @objc func swipeBigTile(_ sender: UIPanGestureRecognizer) {
        let pannedImageView = sender.view! as! UIImageView
        guard pannedImageView.image != nil else { return }
        
        switch sender.state {
        case .began:
            imageViewOrigin = pannedImageView.frame.origin
            if pannedImageView.image == nil {
                break
            }
        case .changed:
            if UIDevice.current.orientation.isPortrait {
                swipeImageUP(view: pannedImageView, sender: sender)
            } else {
                swipeImageLeft(view: pannedImageView, sender: sender)
            }
        case.ended:
            
            let convertedPannedView = pannedImageView.convert(pannedImageView.bounds, to: self.view)
            let convertedY = convertedPannedView.minY
            let orientation = UIDevice.current.orientation.isPortrait
            print(orientation)
            let direction = orientation ? (self.view.bounds.height / 3) : (self.view.bounds.width / 3)
            while pannedImageView.image != nil && convertedY < direction {
                for view in smallTilesCollection {
                    if view.image == nil {
                        swapImage(imageView: pannedImageView, imageView2: view)
                        addMoveToScore()
                        sound.playSound(sound.squareOutSound, speakerBtn)
                    }
                }
            }
            puzzle.checkTiles()
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
        default: break
        }
        pannedImageView.setNeedsUpdateConstraints()
    }
    
    /// allows to move view only on its Y  ^
    func swipeImageUP(view: UIImageView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        if translation.y < 0 {
            view.center =  CGPoint(x: view.center.x,
                                   y: translation.y + view.center.y)
            sender.setTranslation(CGPoint.zero, in: view.superview)
        }
    }
    
    /// allows to move view only on its X  <
    func swipeImageLeft(view: UIImageView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        if translation.x < 0 {
            view.center =  CGPoint(x: translation.x + view.center.x,
                                   y: view.center.y)
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
    
    /// Swapping parameters view images
    func swapImage(imageView: UIImageView, imageView2: UIImageView) {
        let image1 = imageView.image
        let image2 = imageView2.image
        UIView.animate(withDuration: 0.5, animations: {
            imageView2.image = image1
            imageView.image = image2
        })
    }
    
    /// Adding +1 to current score
    func addMoveToScore() {
        var currentScore = Int(movesLbl.text!)!
        currentScore += 1
        movesLbl.text = String(currentScore)
    }
    
    /// Function to make celebration screen once puzzle is completed
    func puzzleCompleted() {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Star
        view.addSubview(confettiView)
        confettiView.startConfetti()
        view.bringSubviewToFront(newGameBtn)
        view.bringSubviewToFront(shareBtn)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {_ in
            self.sound.playSound(self.sound.clapSound, self.speakerBtn)
        }
        sound.soundWithTimer(interval: 6, sound: sound.clapSound, speakerBtn: speakerBtn)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {_ in
            self.shareBtn.shake()
            self.newGameBtn.shake()
        }
    }
    
    /// Function to share current score and puzzle image made
    func displaySharingOptions() {
        // define content to share
        let note = "Took me \(String(movesLbl.text!)) to complete this! Can you beat me ?"
        let image = composeCompletedPuzzleImage()
        let items = [image as Any, note as Any]
        
        // create activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // so that iPads won't crash
        
        // present the view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    /// Function to make an image from current puzzle
    func composeCompletedPuzzleImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(bigTilesStackView.bounds.size, false, 0)
        bigTilesStackView.drawHierarchy(in: bigTilesStackView.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    /// Sets speaker button image and identifier
    func speakerBtnSetup(identifier: String) {
        speakerBtn.setImage(UIImage(systemName: identifier), for: UIControl.State.normal)
        speakerBtn.restorationIdentifier = identifier
    }
}

//MARK: - Extensions

extension UIView {
    /// Changes alpha of view to eather 0 or 1 with animation
    func toggleVisibility(firstTransition : UIView.AnimationOptions, secondTransition: UIView.AnimationOptions) {
        let isVisible = self.alpha == 1
        UIView.transition(with: self, duration: 0.5, options: (isVisible ? firstTransition : secondTransition), animations: {
            self.alpha = isVisible ? 0 : 1
        })
    }
}

extension UIButton {
    /// Changes current image of speaker button
    func toggleSpeakerImage() {
        if self.restorationIdentifier == "speaker.2.fill" {
            saveUserDefaults(identifier: "speaker.slash.fill", bool: true)
        } else {
            saveUserDefaults(identifier: "speaker.2.fill", bool: false)
        }
    }
    
    /// Saving sound settings to userDefaults
    func saveUserDefaults(identifier: String, bool: Bool){
        self.setImage(UIImage(systemName: identifier), for: UIControl.State.normal)
        self.restorationIdentifier = identifier
        UserDefaults.standard.set(bool, forKey: "speaker")
        UserDefaults.standard.synchronize()
    }
}



