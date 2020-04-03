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




class PlayFieldViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    // MARK: - Global variables
    var puzzle = Puzzle()
    var squaresArray = [UIImage]()
    var imageViewOrigin: CGPoint!
    
    let squareInSound = URL(fileURLWithPath: Bundle.main.path(forResource: "In", ofType: "m4a")!)
    let squareOutSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Out", ofType: "m4a")!)
    var audioPlayer = AVAudioPlayer()
    

    
    
    // MARK: - IBOutlets
 
    
    @IBOutlet weak var shareBtn: RoundButton!
    @IBOutlet weak var bigSquaresStackView: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var hintBtnView: UIButton!
    @IBOutlet weak var hintAlphaBackgroundView: UIView!
    
    @IBOutlet var squaresCollection: [CustomImageView]!
    @IBOutlet var bigSquaresCollection: [CustomImageView]!
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        puzzle.addSquareImageToSquareView(collection: squaresCollection)
        movesLbl.text = "0"
        hintImageView.image = puzzle.hintImage
        checkSquares()
        
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
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        displaySharingOptions()
            
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
                    }
                }
            checkSquares()
            addMoveToScore()
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: squareInSound)
                audioPlayer.play()
            } catch {
                print(error)
            }
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
            while pannedImageView.image != nil && convertedY < (self.view.bounds.height / 2.3) {
                for view in squaresCollection {
                    if view.image == nil {
                        swapImage(imageView: pannedImageView, imageView2: view)
                    }
                }
            }
            checkSquares()
            addMoveToScore()
            returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: squareOutSound)
                audioPlayer.play()
            } catch {
                print(error)
            }
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
    
    func checkSquares() {
        for view in squaresCollection {
            if view.image != nil {
                view.borderWidth = 0
            } else {
                view.borderWidth = 0.5
            }
        }
        for view in bigSquaresCollection {
            if view.image != nil {
                squaresArray.append(view.image!)
                view.borderWidth = 0
            } else {
                view.borderWidth = 0.5
            }
        }
        print(squaresArray.count)
        if squaresArray.count == 16 && shareBtn.alpha == 0 {
            shareBtn.toggleVisibility(firstTransition: .curveEaseIn, secondTransition: .curveEaseOut)
            squaresArray.removeAll()
        } else if squaresArray.count < 16 && shareBtn.alpha == 1 {
            squaresArray.removeAll()
            shareBtn.toggleVisibility(firstTransition: .curveEaseIn, secondTransition: .curveEaseOut)
        } else {
            squaresArray.removeAll()
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



