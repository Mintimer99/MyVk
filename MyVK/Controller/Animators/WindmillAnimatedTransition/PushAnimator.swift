//
//  PushAnimator.swift
//  MyVK
//
//  Created by Минтимер Харасов on 05.01.2023.
//

import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.6
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(destination.view)
        
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.frame.origin = transitionContext.containerView.frame.origin
        
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        
        UIView.animate(withDuration: animationDuration) {
            destination.view.transform = .identity
        } completion: { complete in
            transitionContext.completeTransition(complete)
        }
    }
    
    
    
}
