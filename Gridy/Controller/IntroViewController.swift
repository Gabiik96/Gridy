//
//  ViewController.swift
//  Gridy
//
//  Created by Gabriel Balta on 26/02/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class IntroViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var PickBtnLbl: RoundButton!
    @IBOutlet weak var CameraBtnLbl: RoundButton!
    @IBOutlet weak var PhotoLibraryBtnLbl: RoundButton!
    
    var localImages = [UIImage].init()
    var imageToPass: UIImage?

    override func viewWillAppear(_ animated: Bool) {
        PickBtnLbl.alignTextBelow()
        CameraBtnLbl.alignTextBelow()
        PhotoLibraryBtnLbl.alignTextBelow()
    }
    
    // MARK: - Functions

    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            let noPermissionMessage = "Looks like Gridy need access to your camera. Please use Setting app on your device to permit Gridy accessing your camera"
            
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your camera at this time")
        }
    }

    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionMessage = "Looks like Gridy need access to your photos. Please use Setting app on your device to permit Gridy accessing your library"
            
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                self.troubleAlert(message: noPermissionMessage)
            }
        }
        else {
            troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
        }
    }

    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
       }
    
    
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        print("Did finish picking")
        self.imageToPass = selectedImage
        self.performSegue(withIdentifier: "getToImageEditorView", sender: nil)
    }


    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: "Oops...", message:message , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
       
    func collectLocalImageSet() {
        localImages.removeAll()
        let imageNames = ["car", "cat", "christmas", "city", "dog", "ducati", "joker", "smurf", "starWars"]
        
        for name in imageNames {
            if let image = UIImage.init(named: name) {
                localImages.append(image)
            }
        }
    }
       
    func configure() {
        collectLocalImageSet()
    }
    
    func randomImage() {
    
        if localImages.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(localImages.count)))
            let newImage = localImages[randomIndex]
            self.imageToPass = newImage
            self.performSegue(withIdentifier: "getToImageEditorView", sender: nil)
        } else {
            print("Error choosing random image from assets!")
        }
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getToImageEditorView" {
            let nextView: ImageEditorViewController = segue.destination as! ImageEditorViewController
            nextView.imagePicked = self.imageToPass
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    @IBAction func PickBtnPressed(_ sender: RoundButton) {
        randomImage()
    }
    @IBAction func CameraBtnPressed(_ sender: RoundButton) {
        displayCamera()
    }
    @IBAction func PhotoLibraryBtnPressed(_ sender: RoundButton) {
        displayLibrary()
    }
}

// MARK: - Extensions

extension UIButton {
    func alignTextBelow(spacing: CGFloat = 6.0) {
        guard let image = self.imageView?.image else {
            return
        }

        guard let titleLabel = self.titleLabel else {
            return
        }

        guard let titleText = titleLabel.text else {
            return
        }

        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font!
        ])

        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: -image.size.height, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        
    }
}
