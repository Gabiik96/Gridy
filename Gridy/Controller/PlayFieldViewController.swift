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
    var squaresArray = [UIImageView]()
    var imageViewOrigin: CGPoint!
    

    
    
    // MARK: - IBOutlets
 
    
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
        hintAlphaBackgroundView.unHideWithAnimation()
        hintImageView.unHideWithAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hintAlphaBackgroundView.hideWithAnimation()
            self.hintImageView.hideWithAnimation()
        }
    }
    
    @IBAction func newGameBtn(_ sender: Any) {
        puzzle.pickedSquares.removeAll()
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
                view.borderWidth = 0
            } else {
                view.borderWidth = 0.5
            }
        }
    }
}

//MARK: - Extensions

extension UIView {
    func unHideWithAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlDown, animations: {
            self.alpha = self.alpha == 1 ? 0 : 1
            })
        }
    func hideWithAnimation() {
        UIView.transition(with: self, duration: 0.5, options: .transitionCurlUp, animations: {
            self.alpha = self.alpha == 1 ? 0 : 1
        })
    }
}



