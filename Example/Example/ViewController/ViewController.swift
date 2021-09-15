//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//

import UIKit
import WWSignInWith3rd

final class ViewController: UIViewController {

    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// [Apple 第三方登入](https://developer.apple.com)
    @IBAction func signInWithApple(_ sender: UIButton) {
        
        WWSignInWith3rd.Apple.shared.login { result in
            
            switch result {
            case .failure(let error): self.displayResultText(text: error)
            case .success(let info): self.displayResultText(text: info.credential?.email)
            }
        }
    }
    
    /// [Line 第三方登入](https://developers.line.biz)
    @IBAction func signInWithLine(_ sender: UIButton) {
        
        WWSignInWith3rd.Line.shared.login(presenting: self) { result in
            
            switch result {
            case .failure(let error): self.displayResultText(text: error)
            case .success(let profile): self.displayResultText(text: profile?.displayName)
            }
        }
    }

    /// [Twitter 第三方登入](https://developer.twitter.com)
    @IBAction func signInWithTwitter(_ sender: UIButton) {
        
        WWSignInWith3rd.Twitter.shared.login(presenting: self) { result in
            
            switch result {
            case .failure(let error): self.displayResultText(text: error)
            case .success(let token): self.displayResultText(text: token)
            }
        }
    }

    /// [GitHub 第三方登入](https://developer.github.com)
    @IBAction func signInWithGithub(_ sender: UIButton) {
                
        WWSignInWith3rd.GitHub.shared.loginWithWeb(presenting: self) { result in
            
            switch result {
            case .failure(let error): self.displayResultText(text: error)
            case .success(let data): self.displayResultText(text: data)
            }
        }
    }
}

// MARK: - ViewController (private class function)
extension ViewController {
    
    private func displayResultText(text: Any?) {
        
        DispatchQueue.main.async {
            self.resultTextView.text = "\(String(describing: text))"
        }
    }
}
