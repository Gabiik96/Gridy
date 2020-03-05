//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Gabriel Balta on 01/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreGraphics

class ImageEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicked: UIImage!
    
    let screenSize = UIScreen.main.bounds
    

    
    
  
  func createRect() {
      pickedImage.image = imagePicked
      
      
      // Set white background color with custom alpha
      alphaView.backgroundColor = UIColor(white: 255/255, alpha: 0.85)

      // Create the initial layer from the stackView bounds.
      let maskLayer = CAShapeLayer()
      maskLayer.frame = alphaView.bounds

      // Create the frame to cover whole stackView
      let rect = CGRect(
          x: bigStackView.frame.minX,
          y: bigStackView.frame.minY,
          width: bigStackView.bounds.width,
          height: bigStackView.bounds.height)

      // Create the path
      let path = UIBezierPath(rect: alphaView.bounds)
      maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

      // Append the framer to the path so that it is subtracted
      path.append(UIBezierPath(rect: rect))
      maskLayer.path = path.cgPath

      // Set the mask of the alphaview
      alphaView.layer.mask = maskLayer
  }
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var bigStackView: UIStackView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        pickedImage.image = imagePicked
        

 
    }
    
    
    override func viewDidLoad() {
        
               createRect()

        
    }
    
    @IBAction func XBtnPressed(_ sender: UIButton) {
       if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        print("XButton pressed")
        }
    }
    
    
    
   
    
    
    
    

