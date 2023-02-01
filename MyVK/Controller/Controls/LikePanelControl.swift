//
//  LikePanelControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 28.12.2022.
//

import UIKit

class LikePanelControl: UIControl {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    var likesCount = 0 {
        didSet {
            likeLabel.text = String(likesCount)
        }
    }
    var isLiked: Bool = false {
        didSet {
            setupLikes()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNIB()
    }
    
    private func loadFromNIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("LikePanelControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
    
    override func draw(_ rect: CGRect) {
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
        likeLabel.text = String(likesCount)
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func tap() {
        isLiked.toggle()
        animateLike()
    }
    
    private func animateLike() {
        if isLiked {
            UIView.transition(with: likeLabel,
                              duration: 0.3,
                              options: .transitionFlipFromTop) {
                self.likeLabel.textColor = .red
                self.likesCount += 1
            }
        } else {
            UIView.transition(with: likeLabel,
                              duration: 0.3,
                              options: .transitionFlipFromBottom) {
                self.likeLabel.textColor = .black
                self.likesCount -= 1
            }
        }
    }
    
    private func setupLikes() {
        if isLiked {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeLabel.textColor = .red
        } else {
            likeButton.tintColor = .black
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeLabel.textColor = .black
        }
    }


}
