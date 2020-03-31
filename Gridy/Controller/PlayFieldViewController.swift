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
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var topSmallSquaresStack: UIStackView!
    @IBOutlet weak var middleSmallSquaresStack: UIStackView!
    @IBOutlet weak var bottomSmallSquaresStack: UIStackView!
    @IBOutlet weak var smallSquareImagesStack: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    @IBOutlet weak var hintImageView: UIImageView!
    @IBOutlet weak var hintBtnView: UIButton!
    @IBOutlet weak var hintAlphaBackgroundView: UIView!
    
    
    // MARK: - View lifecycle
    override func viewWillAppear(_ animated: Bool) {
        puzzle.addSquaresToAllImageViews(bottom: bottomSmallSquaresStack,
                                         middle: middleSmallSquaresStack,
                                         top:     topSmallSquaresStack)
        hintImageView.image = puzzle.hintImage


        
    }
    
    override func viewDidLoad() {
      
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
