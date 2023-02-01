//
//  SeenControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 30.12.2022.
//

import UIKit

class SeenControl: UIControl {

    @IBOutlet weak var seenButton: UIButton!
    @IBOutlet weak var seenLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXIB()
    }
    
    private func loadFromXIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("SeenControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }

}
