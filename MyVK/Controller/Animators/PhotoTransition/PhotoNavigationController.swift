//
//  PhotoNavigationController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 06.01.2023.
//

import UIKit

class PhotoNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop && fromVC is PhotoSwipeViewController {
            return PhotoPopAnimator()
     
        }
        return nil
    }
}
