//
//  PopAnimator.swift
//  MyVK
//
//  Created by Минтимер Харасов on 05.01.2023.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.6
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        source.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        UIView.animate(withDuration: animationDuration) {
            source.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        } completion: { complete in
            if complete && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            } else {
                destination.view.transform = .identity
            }
            transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)
        }
    }
    
}
