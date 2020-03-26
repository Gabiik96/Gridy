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

class ImageEditorViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

//MARK:- Global variables

    var imagePicked: UIImage!
    var initialImageViewOffSet = CGPoint()
 
//MARK:- IBOutlets

    @IBOutlet var vieww: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var bigStackView: UIStackView!
    @IBOutlet weak var XBtn: UIButton!
    
    
    
//MARK:- View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        pickedImage.image = imagePicked
        XBtn.setNeedsDisplay()
        alphaView.setNeedsDisplay()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(movePickedImage(_:)))
        pickedImage.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
                   
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotatePickedImage(_:)))
        pickedImage.addGestureRecognizer(rotationGestureRecognizer)
        rotationGestureRecognizer.delegate = self
                   
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scalePickedImage(_:)))
        pickedImage.addGestureRecognizer(pinchGestureRecognizer)
        pinchGestureRecognizer.delegate = self
 
    }
    
    override func viewDidLoad() {
        createRect()
        view.bringSubviewToFront(XBtn)
        
    }
    
//MARK: - IBActions
    
    @IBAction func XBtnPressed(_ sender: Any) {
       if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        print("XButton pressed")
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        print("startBtn pressed")
    }
    
//MARK: - Functions
    
    @objc func movePickedImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: pickedImage.superview)
        
        if sender.state == .began {
            initialImageViewOffSet = pickedImage.frame.origin
        }
        
        let position = CGPoint(x: translation.x + initialImageViewOffSet.x - pickedImage.frame.origin.x,
                               y: translation.y + initialImageViewOffSet.y - pickedImage.frame.origin.y)
        pickedImage.transform = pickedImage.transform.translatedBy(x: position.x, y: position.y)
    }
          
    @objc func rotatePickedImage(_ sender: UIRotationGestureRecognizer) {
        pickedImage.transform = pickedImage.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
          
    @objc func scalePickedImage(_ sender: UIPinchGestureRecognizer) {
        pickedImage.transform = pickedImage.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
        
    }
      
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
            -> Bool {
                
        // simultaneous gesture recognition will be supported for pickedImage view
        if gestureRecognizer.view != pickedImage {
            return false
        }
                
        // TapGestureRecognition will not be supported by simultaneous gesture recognition
        if gestureRecognizer is UITapGestureRecognizer
            || otherGestureRecognizer is UITapGestureRecognizer{
            return false
        }
                
        return true
    }
    
    
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
            width: view.frame.size.width - 40,
            height: bigStackView.frame.size.height)

        // Create the path
        let path = UIBezierPath(rect: alphaView.bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        // Append the framer to the path so that it is subtracted
        path.append(UIBezierPath(rect: rect))
        maskLayer.path = path.cgPath

        // Set the mask of the alphaview
        alphaView.layer.mask = maskLayer
    }
      
}
    
    
    
   
    
    
    
    

