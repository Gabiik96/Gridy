//
//  Square.swift
//  Gridy
//
//  Created by Gabriel Balta on 30/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

struct Puzzle {
    
    
    var pickedSquares: [UIImage] = []
    var hintImage: UIImage?
    
    // create an array of slices from an image using the desired amount of columns and rows, then store that array inside another array
    func cropImage(for image: UIImage) -> [UIImage] {
        let row = 4
        let column = 4
        
        let height = (image.size.height) / CGFloat(row)
        let width = (image.size.width) / CGFloat(column)
        let scale = (image.scale)
        
        // empty array of arrays of images
        var imageArray = [UIImage]()
        
        // for each in 0 ... number of rows
        for y in 0..<row {
            
            // for each in 0 ... number of columns
            for x in 0..<column {
                
                // creating a bitmap of an image with specific options
                // size = width & height, opacity = false, scale = 0
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
                
                // creating a slice of the image
                let i = image.cgImage?.cropping(to: CGRect.init(x: CGFloat(x) * width * scale, y:  CGFloat(y) * height * scale , width: width * scale, height: height * scale)  )
                
                // add slice of image
                let newImage = UIImage.init(cgImage: i!)
                
                // add newImage to yArray
                imageArray.append(newImage)
                
                
                
                // end drawing image
                UIGraphicsEndImageContext();
                
            }
            
        }
        // return imageArray
        print("[\(imageArray.count)]<- returning sliced images")
        return imageArray
    }
    
    mutating func addSquareImageToSquareView(tag: Int, bottom: UIStackView, middle: UIStackView, top: UIStackView ) {
        
        if tag >= 1 && tag <= 4 {
            let bottom = bottom.viewWithTag(tag) as! UIImageView
            bottom.image = pickedSquares[tag]
            pickedSquares.remove(at: tag)
        }
        
        let index = Int.random(in: 0...(pickedSquares.count - 1))
        let top = top.viewWithTag(tag) as! UIImageView
        top.image = pickedSquares[index]
        pickedSquares.remove(at: index)
        let index2 = Int.random(in: 0...(pickedSquares.count - 1))
        let middle = middle.viewWithTag(tag) as! UIImageView
        middle.image = pickedSquares[index2]
        pickedSquares.remove(at: index2)
    }
    
    mutating func addSquaresToAllImageViews(bottom: UIStackView, middle: UIStackView, top: UIStackView) {
             var index = 1
           while index <= 6 {
                   pickedSquares.shuffle()
            addSquareImageToSquareView(tag: index, bottom: bottom, middle: middle, top: top)
                   index += 1
           }
    }
}
