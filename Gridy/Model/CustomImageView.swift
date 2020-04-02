//
//  CustomView.swift
//  Gridy
//
//  Created by Gabriel Balta on 31/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    
    @IBInspectable var borderWidth: CGFloat = 0{
         didSet{
             self.layer.borderWidth = borderWidth
         }
     }

     @IBInspectable var borderColor: UIColor = UIColor.clear{
         didSet{
             self.layer.borderColor = borderColor.cgColor
         }
     }

    var initialSquareOffSet = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(moveSquareImage))
//        self.gestureRecognizers = [panRecognizer]
        initialSquareOffSet = self.frame.origin

    }
    
//    @objc func moveSquareImage(_ sender: UIPanGestureRecognizer) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "PlayFieldViewController") as! PlayFieldViewController
//
//        switch sender.state {
//            case .began:
//                initialSquareOffSet = self.frame.origin
//
//            case .changed:
//                moveViewWithPan(sender: sender)
//
//            case.ended:
//                for view in viewController.bigSquaresCollection {
//                    if self.frame.intersects(view.frame) {
////                            returnViewToOrigin(view: self, location: initialSquareOffSet)
////                        view.image = self.image
//                    }
//                }
//
//
//                returnViewToOrigin(view: self, location: initialSquareOffSet)
//
//            default: break
//        }
//        self.setNeedsUpdateConstraints()
//    }
//
//    func returnViewToOrigin(view: UIView, location: CGPoint) {
//        UIView.animate(withDuration: 0.5, animations: {
//        view.frame.origin = location
//        })
//    }
//
//    func moveViewWithPan(sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: self.superview!.superview!.superview)
//        let position = CGPoint(x: translation.x + initialSquareOffSet.x - self.frame.origin.x,
//                               y: translation.y + initialSquareOffSet.y - self.frame.origin.y)
//
//        self.transform = self.transform.translatedBy(x: position.x, y: position.y)
//    }
//
//    func swapImage(image1: UIImageView, image2: UIImageView) {
//        let image11 = image1.image
//        let image22 = image2.image
//        image2.image = image11
//        image1.image = image22
//    }
}

