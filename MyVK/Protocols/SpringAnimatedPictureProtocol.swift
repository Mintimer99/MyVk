//
//  SpringAnimatedPictureProtocol.swift
//  MyVK
//
//  Created by Минтимер Харасов on 02.01.2023.
//

import UIKit

protocol SpringAnimatedPictureProtocol {
    var pictureImageView: UIImageView! { get set}
    func animatePicture()
}

extension SpringAnimatedPictureProtocol {
    func animatePicture() {
        UIView.animate(withDuration: 0.2) {
            self.pictureImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.2,
                           initialSpringVelocity: 5) {
                self.pictureImageView.transform = .identity
            }
        }
    }
}
