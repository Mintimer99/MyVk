//
//  SearchControl.swift
//  MyVK
//
//  Created by Минтимер Харасов on 03.01.2023.
//

import UIKit

class SearchControl: UIControl {

   
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var cancelButtonConstraint: NSLayoutConstraint!
    @IBOutlet var searchImageConstraint: NSLayoutConstraint!
    
    private var isSearching = false
    var searchText: String {
        textField.text ?? ""
    }
    
    override func awakeFromNib() {
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.borderWidth = 1
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
        let viewFromXIB = Bundle.main.loadNibNamed("SearchControl", owner: self)?.first as! UIView
        viewFromXIB.frame = self.bounds
        addSubview(viewFromXIB)
    }
    
    
    @IBAction func cancelSearching(_ sender: UIButton) {
        textField.resignFirstResponder()
        textField.text = nil
        sendActions(for: .editingChanged)
        animateView()
    }
    
    func animateView() {
        animateTextFieldBorders()
        animateConstraints()
        isSearching.toggle()
    }
    
    private func animateConstraints() {
        cancelButtonConstraint.isActive.toggle()
        searchImageConstraint.isActive.toggle()
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 15) {
            self.layoutIfNeeded()
        }
    }
    
    private func animateTextFieldBorders() {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = isSearching ? 15 : 5
        animation.toValue = isSearching ? 5 : 15
        animation.duration = 0.2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        textField.layer.add(animation, forKey: nil)
    }
    
}

// MARK: - UITextFieldDelegate

extension SearchControl: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animateView()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = nil
        sendActions(for: .editingChanged)
        animateView()
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        sendActions(for: .editingChanged)
    }
    
    
}
