//
//  FriendTableViewCell.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit

class FriendTableViewCell: UITableViewCell, SpringAnimatedPictureProtocol {
  
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        pictureImageView.layer.cornerRadius = pictureImageView.frame.width / 2
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        pictureImageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func tap() {
        animatePicture()
    }
}
