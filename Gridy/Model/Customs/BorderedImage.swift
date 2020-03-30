//
//  RoundedButton.swift
//  Gridy
//
//  Created by Gabriel Balta on 01/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//
//
//  ImageViewBorder.swift
//  Gridy
//
//  Created by Gabriel Balta on 02/03/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedImage: UIImageView{

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
}

