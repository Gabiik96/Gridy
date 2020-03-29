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


class PlayFieldViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var pickedSquares: [UIImage] = []
    
    
    @IBOutlet weak var topSmallSquaresStack: UIStackView!
    @IBOutlet weak var middleSmallSquaresStack: UIStackView!
    @IBOutlet weak var bottomSmallSquaresStack: UIStackView!
    @IBOutlet weak var smallSquareImagesStack: UIStackView!
    @IBOutlet weak var movesLbl: UILabel!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
 
    }
    
    override func viewDidLoad() {
        print(pickedSquares.count)
        var index = 4
        while index >= 6 {
            while index >= 0 {
                pickedSquares.shuffle()
                addSquareImageToSquareView(tag: index)
                index += -1
            }
            pickedSquares.shuffle()
            addSquareImageToSquareView(tag: index)
            index += 1
        }
        
    }
    
    
    @IBAction func newGameBtn(_ sender: Any) {
        pickedSquares.removeAll()
        if let nav = self.navigationController {
                 nav.popViewController(animated: true)
             } else {
                 self.dismiss(animated: true, completion: nil)
             }
    }
    
    func addSquareImageToSquareView(tag: Int) {
        
        if tag >= 0 {
            bottomSmallSquaresStack.viewWithTag(tag)?.backgroundColor = UIColor(patternImage: pickedSquares[tag])
            pickedSquares.remove(at: tag)
        }
        
        let index = Int.random(in: 0...(pickedSquares.count - 1))
        topSmallSquaresStack.viewWithTag(tag)?.backgroundColor = UIColor(patternImage: pickedSquares[index])
        pickedSquares.remove(at: index)
        let index2 = Int.random(in: 0...(pickedSquares.count - 1))
        middleSmallSquaresStack.viewWithTag(tag)?.backgroundColor = UIColor(patternImage: pickedSquares[index2])
        pickedSquares.remove(at: index2)

        
    }
    
}
