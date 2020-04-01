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
    }
    
   
  
    @objc func moveSquareImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.superview!.superview!.superview)
              
        switch sender.state {
            case .began:
                initialSquareOffSet = self.frame.origin
                
            case .changed:
                let position = CGPoint(x: translation.x + initialSquareOffSet.x - self.frame.origin.x,
                                       y: translation.y + initialSquareOffSet.y - self.frame.origin.y)
                
                self.transform = self.transform.translatedBy(x: position.x, y: position.y)
                
            case.ended:
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
}

