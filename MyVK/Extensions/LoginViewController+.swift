//
//  LoginViewController+.swift
//  MyVK
//
//  Created by Минтимер Харасов on 26.12.2022.
//

import UIKit

extension LoginViewController {
    func showLoginErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "Incorrect login or password",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { _ in
            self.loginTextField.text = nil
            self.passwordTextField.text = nil
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
