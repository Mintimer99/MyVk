//
//  LoadingDotsControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 02.01.2023.
//

import UIKit

class LoadingDotsControl: UIControl {

    @IBOutlet var dots: [UIButton]!
    
    private var delay: Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXIB()
    }
    
    private func loadFromXIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("LoadingDotsControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
    
    override func awakeFromNib() {
        animateDots()
    }
    
    private func animateDots() {
        for dot in dots {
            UIView.animate(withDuration: 1,
                           delay: delay,
                           options: [.repeat, .autoreverse]) {
                dot.alpha = 0.5
            }
            delay += 0.33
        }
    }
    
}
