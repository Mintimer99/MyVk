//
//  OpenPhotoSegue.swift
//  MyVK
//
//  Created by Минтимер Харасов on 05.01.2023.
//

import UIKit
import PBImageView

class OpenPhotoSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let containerView = source.view.superview,
              let sourceView = source as? FriendPhotosController,
              let indexPath = sourceView.collectionView.indexPathsForSelectedItems?.first,
              let selectedCell = sourceView.collectionView.cellForItem(at: indexPath) as? FriendPhotoCell,
              let selectedImage = selectedCell.avatarPicture.imageView
        else { return }
        
        let imageView = PBImageView(image: selectedCell.avatarPicture.imageView.image)
        let targetOrigin = sourceView.collectionView.convert(selectedCell.frame.origin, to: containerView)
        imageView.frame = CGRect(origin: targetOrigin, size: selectedImage.frame.size)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        containerView.addSubview(imageView)
        selectedImage.alpha = 0
        
        let targetFrame = destination.view.frame
        
        UIView.animate(withDuration: 0.3,
                       delay: 0) {
            self.source.view.alpha = 0
            imageView.frame = targetFrame
            imageView.contentMode = .scaleAspectFit
        } completion: { _ in
            self.source.navigationController?.pushViewController(self.destination, animated: false)
            selectedImage.alpha = 1
            self.source.view.alpha = 1
        }
        
    }
    
}
