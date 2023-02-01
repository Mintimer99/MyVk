//
//  LCRConrol.swift
//  MyVK
//
//  Created by Mintimer Kharasov on 18/01/23.
//

import UIKit

class LCRConrol: UIControl {
    @IBOutlet weak var seenView: SeenControl!
    @IBOutlet weak var repostButton: ShareControl!
    @IBOutlet weak var commentsButton: CommentsControl!
    @IBOutlet weak var likeButton: LikePanelControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXIB()
    }
    
    private func loadFromXIB() {
        let viewFromXIB = Bundle.main.loadNibNamed("LCRControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
}
