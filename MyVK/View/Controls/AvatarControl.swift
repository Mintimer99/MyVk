//
//  AvatarControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit

class AvatarControl: UIControl {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
    }

}
