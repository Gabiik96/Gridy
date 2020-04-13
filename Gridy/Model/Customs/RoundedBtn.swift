//
//  ImageViewBorder.swift
//  Gridy
//
//  Created by Gabriel Balta on 03/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

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
    
    func shake(for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 10) {
          let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3) {
              self.transform = CGAffineTransform(translationX: translation, y: 0)
          }
          propertyAnimator.addAnimations({
              self.transform = CGAffineTransform(translationX: 0, y: 0)
          }, delayFactor: 0.2)
          propertyAnimator.startAnimation()
      }
}

