//
//  ViewController.swift
//  Gridy
//
//  Created by Gabriel Balta on 26/02/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var PickBtnLbl: RoundButton!
    @IBOutlet weak var CameraBtnLbl: RoundButton!
    @IBOutlet weak var PhotoLibraryBtnLbl: RoundButton!
    

    override func viewWillAppear(_ animated: Bool) {
        PickBtnLbl.alignTextBelow()
        CameraBtnLbl.alignTextBelow()
        PhotoLibraryBtnLbl.alignTextBelow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view.
    }

    @IBAction func PickBtnPressed(_ sender: RoundButton) {
    }
    @IBAction func CameraBtnPressed(_ sender: RoundButton) {
    }
    @IBAction func PhotoLibraryBtnPressed(_ sender: RoundButton) {
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
