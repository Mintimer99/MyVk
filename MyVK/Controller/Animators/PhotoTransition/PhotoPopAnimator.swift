//
//  PhotoPopAnimator.swift
//  MyVK
//
//  Created by Минтимер Харасов on 06.01.2023.
//

import UIKit
import PBImageView

class PhotoPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration: CGFloat = 0.3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) as? PhotoSwipeViewController,
              let destiation = transitionContext.viewController(forKey: .to) as? FriendPhotosController,
              let selectedCell = destiation.collectionView.cellForItem(at: IndexPath(item: source.currentIndex, section: 0)) as? FriendPhotoCell
        else { return }
        
        transitionContext.containerView.addSubview(destiation.view)
        transitionContext.containerView.sendSubviewToBack(destiation.view)
        
        source.view.frame = transitionContext.containerView.frame
        destiation.view.frame = transitionContext.containerView.frame
        
        let imageView = PBImageView(image: source.imageView.image)
        imageView.frame = source.imageView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let targetOrigin = destiation.collectionView.convert(selectedCell.frame.origin, to: transitionContext.containerView)
        let targetFrame = CGRect(origin: targetOrigin, size: selectedCell.frame.size)
        
        transitionContext.containerView.addSubview(imageView)
        selectedCell.avatarPicture.alpha = 0
        source.imageView.alpha = 0
        
        UIView.animate(withDuration: animationDuration) {
            source.view.alpha = 0
            imageView.frame = targetFrame
            imageView.contentMode = .scaleAspectFill
        } completion: { finished in
            if finished && !transitionContext.transitionWasCancelled {
                selectedCell.avatarPicture.alpha = 1
                source.removeFromParent()
                imageView.removeFromSuperview()
            } else {
                source.view.alpha = 1
                source.imageView.alpha = 1
                imageView.removeFromSuperview()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
        
    }
}

