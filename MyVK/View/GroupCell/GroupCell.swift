//
//  GroupCell.swift
//  MyVK
//
//  Created by Минтимер Харасов on 27.12.2022.
//

import UIKit

class GroupCell: UITableViewCell, SpringAnimatedPictureProtocol {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func awakeFromNib() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        pictureImageView.addGestureRecognizer(tapRecognizer)
        pictureImageView.layer.cornerRadius = pictureImageView.frame.height / 2
    }
    
    @objc private func tap() {
        animatePicture()
    }
}
