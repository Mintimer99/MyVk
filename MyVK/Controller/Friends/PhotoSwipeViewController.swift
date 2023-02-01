//
//  PhotoSwipeViewController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 03.01.2023.
//

import UIKit
import Kingfisher
import RealmSwift

class PhotoSwipeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    private var additionalImageView: UIImageView!
    
    private var propertyAnimator = UIViewPropertyAnimator()
    private var swipeDirection: UISwipeGestureRecognizer.Direction!
    
    var photos: Results<Photo>!
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setPanRecognizer()
    }
    
    private func setImage() {
        imageView.kf.setImage(with: URL(string: photos[currentIndex].url))
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setupAdditionalImageView() {
        additionalImageView = UIImageView()
        additionalImageView.frame = imageView.frame
        additionalImageView.contentMode = .scaleAspectFit
        view.addSubview(additionalImageView)
        
        if swipeDirection == .left {
            additionalImageView.kf.setImage(with: URL(string: photos[currentIndex + 1].url))
            additionalImageView.transform = CGAffineTransform(translationX: imageView.frame.width, y: 0)
            view.sendSubviewToBack(imageView)
            
        } else if swipeDirection == .right {
            additionalImageView.kf.setImage(with: URL(string: photos[currentIndex - 1].url))
            additionalImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            additionalImageView.alpha = 0
            view.sendSubviewToBack(additionalImageView)
        }
    }
    
    private func setPanRecognizer() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            if recognizer.translation(in: view).x > 0,
               currentIndex > 0 {
                swipeDirection = .right
                animateSwipeRight(for: recognizer)
                
            } else if recognizer.translation(in: view).x < 0,
                      currentIndex < photos.count - 1 {
                swipeDirection = .left
                animateSwipeLeft(for: recognizer)
            } else if recognizer.translation(in: view).y > 0 {
                navigationController?.popViewController(animated: true)
            }
            
            
        case .changed:
            
            let percent = recognizer.translation(in: view).x / 200
            propertyAnimator.fractionComplete = swipeDirection == .right ? percent : -percent
            
            
        case .ended:
            if propertyAnimator.fractionComplete > 0.5 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            } else {
                propertyAnimator.isReversed = true
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            
        default:
            break
        }
        
    }
    
    private func animateSwipeRight(for recognizer: UIPanGestureRecognizer) {
        setupAdditionalImageView()
        propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .linear)
        
        propertyAnimator.addAnimations {
            self.imageView.transform = CGAffineTransform(translationX: self.imageView.frame.width, y: 0)
            self.additionalImageView.alpha = 1
            self.additionalImageView.transform = .identity
        }
        
        propertyAnimator.addCompletion { position in
            switch position {
            case .end:
                self.setCompletion()
            default:
                break
            }
        }
    }
    
    private func animateSwipeLeft(for recognizer: UIPanGestureRecognizer) {
        setupAdditionalImageView()
        propertyAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .linear)
        
        propertyAnimator.addAnimations {
            self.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.imageView.alpha = 0
            self.additionalImageView.transform = .identity
        }
        
        propertyAnimator.addCompletion { position in
            switch position {
            case .end:
                self.setCompletion()
            default:
                break
            }
        }
    }
    
    private func setCompletion() {
        self.currentIndex += swipeDirection == .left ? 1 : -1
        self.setImage()
        self.imageView.alpha = 1
        self.imageView.transform = .identity
        self.additionalImageView.removeFromSuperview()
        self.additionalImageView = nil
    }
    
}
