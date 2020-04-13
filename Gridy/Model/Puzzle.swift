//
//  Square.swift
//  Gridy
//
//  Created by Gabriel Balta on 30/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

struct Puzzle {
    
    var originalLocations: [UIImage] = []
    var pickedSquares: [UIImage] = []
    var hintImage: UIImage?
    
    // create an array of slices from an image using the desired amount of columns and rows, then store that array inside another array
    mutating func cropImage(for image: UIImage) -> [UIImage] {
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
                
                // add newImage to Array
                imageArray.append(newImage)
                
                // end drawing image
                UIGraphicsEndImageContext();
                
            }
            
        }
        
        
        // return imageArray
        print("[\(imageArray.count)]<- returning sliced images")
        return imageArray
    }
    
    mutating func addSquareImageToSquareView(collection: [UIImageView]) {
        pickedSquares.shuffle()
        for view in collection {
            let randomInt = Int.random(in: 0...(pickedSquares.count - 1))
            view.image = pickedSquares[randomInt]
            pickedSquares.remove(at: randomInt)
        }
    }
}
