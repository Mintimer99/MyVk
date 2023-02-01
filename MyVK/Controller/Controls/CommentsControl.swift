//
//  CommentsControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 30.12.2022.
//

import UIKit

class CommentsControl: UIControl {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromXIB()
    }
    
    private func loadViewFromXIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("CommentsControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
}
