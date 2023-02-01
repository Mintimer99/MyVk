//
//  ShareControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 30.12.2022.
//

import UIKit

class ShareControl: UIControl {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        backgroundView.layer.cornerRadius = backgroundView.bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXIB()
    }
    
    private func loadFromXIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("ShareControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
    
}
