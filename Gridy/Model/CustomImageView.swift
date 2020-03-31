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
        let translation = sender.translation(in: self.superview)
              
        if sender.state == .began {
            initialSquareOffSet = self.frame.origin
            }

        let position = CGPoint(x: translation.x + initialSquareOffSet.x - self.frame.origin.x,
                               y: translation.y + initialSquareOffSet.y - self.frame.origin.y)
        self.transform = self.transform.translatedBy(x: position.x, y: position.y)
    }
    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // Promote the touched view
//        self.superview?.bringSubviewToFront(self)
//
//        // Remember original location
//        initialSquareOffSet = self.center
//    }
}
