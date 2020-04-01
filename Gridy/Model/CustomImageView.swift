//
//  CustomView.swift
//  Gridy
//
//  Created by Gabriel Balta on 31/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

class CustomImageView: BorderedImage {

    var initialSquareOffSet = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(moveSquareImage))
        self.gestureRecognizers = [panRecognizer]
        initialSquareOffSet = self.frame.origin
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlayFielViewController") as! PlayFieldViewController
        viewController.addImageViewToArray(view: self)
    }
    
    @objc func moveSquareImage(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                initialSquareOffSet = self.frame.origin
                   
            case .changed:
                moveViewWithPan(sender: sender)
                   
            case.ended:
//
//                if self.frame.intersects() {
//                    
//                }
                
                
                returnViewToOrigin(view: self, location: initialSquareOffSet)
               
            default: break
        }
        self.setNeedsUpdateConstraints()
    }
    
    func returnViewToOrigin(view: UIView, location: CGPoint) {
        UIView.animate(withDuration: 0.5, animations: {
        view.frame.origin = location
        })
    }
    
    func moveViewWithPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.superview!.superview!.superview)
        let position = CGPoint(x: translation.x + initialSquareOffSet.x - self.frame.origin.x,
                               y: translation.y + initialSquareOffSet.y - self.frame.origin.y)
        
        self.transform = self.transform.translatedBy(x: position.x, y: position.y)
    }
}

