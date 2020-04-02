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
    
    @IBOutlet var squaresCollection: [UIImageView]!
    @IBOutlet var bigSquaresCollection: [UIImageView]!
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        puzzle.addSquareImageToSquareView(collection: squaresCollection)

        hintImageView.image = puzzle.hintImage
        
        for view in squaresCollection {
            addPanGesture(view: view)
        }
        
        for view in bigSquaresCollection {
            addPanGesture(view: view)
        }

        
    }
    
    override func viewDidLoad() {
  
        print(squaresCollection.count)
        print(bigSquaresCollection.count)
      
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

        @objc func moveSquareImage(_ sender: UIPanGestureRecognizer) {
            let pannedImageView = sender.view! as! UIImageView
            
            switch sender.state {
                case .began:
                    imageViewOrigin = pannedImageView.frame.origin
                case .changed:
                    moveViewWithPan(view: pannedImageView, sender: sender)
    
                case.ended:
                    for view in bigSquaresCollection {
                        if pannedImageView.bounds.intersects(view.bounds) {
                            print("intersects")
                            if pannedImageView.image != view.image {
                                returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
                                swapImage(imageView: pannedImageView, imageView2: view)
                            }
//                            else if pannedImageView.image != nil && view.image == nil {
//                                returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
//                                addImage(imageView: pannedImageView, imageView2: view)
//                            }
                        }
                    }
    
    
                    returnViewToOrigin(view: pannedImageView, location: imageViewOrigin)
    
                default: break
            }
            pannedImageView.setNeedsUpdateConstraints()
        }
    func addPanGesture(view: UIImageView) {
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(moveSquareImage))
        view.gestureRecognizers = [panRecognizer]
    }
    
        func returnViewToOrigin(view: UIImageView, location: CGPoint) {
            UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin = location
            })
        }
    
    func moveViewWithPan(view: UIImageView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        view.center = CGPoint(x: translation.x + view.center.x,
                               y: translation.y + view.center.y)
        sender.setTranslation(CGPoint.zero, in: view)
//            view.transform = view.transform.translatedBy(x: position.x, y: position.y)
        }
    
        func swapImage(imageView: UIImageView, imageView2: UIImageView) {
            let image1 = imageView.image
            let image2 = imageView2.image
            imageView2.image = image1
            imageView.image = image2
        }
    func addImage(imageView: UIImageView, imageView2: UIImageView) {
        imageView2.image = imageView.image
        imageView2.image = nil
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



