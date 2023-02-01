//
//  WKLoginViewController.swift
//  MyVK
//
//  Created by Минтимер Харасов on 08.01.2023.
//

import UIKit
import WebKit
import KeychainSwift
import FirebaseDatabase

class WKLoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        goToVK()
    }
    
    private func goToVK() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "51525787"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
    
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce( [String: String]() ) { partialResult, param in
                var dict = partialResult
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
     
        guard let token = params["access_token"],
              let userID = params["user_id"],
              let id = Int(userID)
        else { return }
        
        KeychainSwift().set(token, forKey: "vk_access_token")
        KeychainSwift().set(userID, forKey: "vk_user_id")
        
        Session.instance.token = token
        Session.instance.userID = id
        
        FBDatabaseManager().addNewUser()
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "openAppSegue", sender: nil)
    }

}
