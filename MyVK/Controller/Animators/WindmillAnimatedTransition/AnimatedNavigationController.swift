//
//  AnimatedNavigationController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 05.01.2023.
//

import UIKit

class InteractiveNavigationTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    
    weak var viewController: UIViewController? {
        didSet {
            let panRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pan))
            panRecognizer.edges = .left
            viewController?.view.addGestureRecognizer(panRecognizer)
        }
    }
    
    @objc func pan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view).x
            let relativeTranslation = translation / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(relativeTranslation, 1))
            
            shouldFinish = progress > 0.33
            
            self.update(progress)
        case .ended:
            hasStarted = false
            shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            hasStarted = false
            self.cancel()
        default:
            return
        }
    }
}

class AnimatedNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition = InteractiveNavigationTransition()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            interactiveTransition.viewController = toVC
            return PushAnimator()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return PopAnimator()
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    

}
