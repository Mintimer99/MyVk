//
//  ViewController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 25.12.2022.
//

import UIKit
import Alamofire
import KeychainSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
    @IBAction func login(_ sender: UIButton) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              login == "",
              password == ""
        else {  showLoginErrorAlert()
            return
        }
        if let token = KeychainSwift().get("vk_access_token"),
           let userId = KeychainSwift().get("vk_user_id"),
            let intUserId = Int(userId) {
            Session.instance.token = token
            Session.instance.userID = intUserId
            performSegue(withIdentifier: "openAppSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

}

