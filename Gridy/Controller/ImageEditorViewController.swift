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

class ImageEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicked: UIImage!
    
    @IBOutlet weak var pickedImage: UIImageView!
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        pickedImage.image = imagePicked
        
    }
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func XBtnPressed(_ sender: UIButton) {
       if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    
    
    

