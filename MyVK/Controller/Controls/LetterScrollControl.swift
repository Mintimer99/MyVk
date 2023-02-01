//
//  LetterScrollControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 29.12.2022.
//

import UIKit

class LetterScrollControl: UIControl {

    @IBOutlet weak var stackView: UIStackView!
    
    var letters: [String]! {
        didSet {
            setupPanel()
        }
    }
    var selectedLetter: String = ""
    

    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    private func setupPanel() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for letter in letters {
            createLabel(for: letter)
        }
        
        let fillView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
        stackView.addArrangedSubview(fillView)
    }
    
    private func createLabel(for letter: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 20))
        label.text = letter

        label.textColor = .black
        stackView.addArrangedSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self)
        else {return}
        
        for letter in stackView.arrangedSubviews {
            if letter.frame.contains(location) {
                selectedLetter = (letter as? UILabel)?.text ?? ""
                sendActions(for: .allTouchEvents)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        
        for letter in stackView.arrangedSubviews {
            if letter.frame.contains(location) {
                selectedLetter = (letter as? UILabel)?.text ?? ""
                sendActions(for: .allTouchEvents)
            }
        }
    }

    

}
