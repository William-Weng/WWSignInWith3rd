//
//  SignInWith3rd+LINE.swift
//  SignInWith3rd
//
//  Created by William.Weng on 2021/8/6.
//

import UIKit
import LineSDK

// MARK: - 第三方登入
extension WWSignInWith3rd {
    
    /// [LINE SDK - 5.7.0](https://github.com/line/line-sdk-ios-swift)
    open class Line: NSObject {
        
        public static let shared = Line()
        
        private var channelId: String?
        private var universalLinkURL: String?
        private var channelSecret: String?

        private var completionBlock: ((Result<UserProfile?, Error>) -> Void)?
        
        private override init() {}
    }
}

// MARK: - LoginButtonDelegate
extension WWSignInWith3rd.Line: LoginButtonDelegate {
    
    public func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) { completionBlock?(.success(loginResult.userProfile)) }
    public func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) { completionBlock?(.failure(error)) }
}

// MARK: - WWSignInWith3rd.Line (public class function)
extension WWSignInWith3rd.Line {
    
    /// [參數設定](https://developers.line.biz/en/docs/ios-sdk/swift/integrate-line-login/#set-up-linesdk-framework-and-channel-id)
    /// - Parameters:
    ///   - channelId: [String](https://developers.line.biz/en/docs/ios-sdk/objective-c/setting-up-project/)
    ///   - channelSecret: [String](https://cg2010studio.com/2020/06/20/ios-整合-line-login/)
    ///   - universalLinkURL: [String](https://developers.line.biz/)
    public func configure(channelId: String, channelSecret: String, universalLinkURL: String) {
        
        self.channelId = channelId
        self.channelSecret = channelSecret
        self.universalLinkURL = universalLinkURL
        
        LoginManager.shared.setup(channelID: channelId, universalLinkURL: URL._standardization(string: universalLinkURL))
    }

    /// [登入](https://developers.line.biz/en/docs/ios-sdk/swift/integrate-line-login/#perform-login-process)
    /// - Parameters:
    ///   - viewController: UIViewController
    ///   - permissions: Set<LoginPermission>
    ///   - completion: Result<UserProfile?, Error>
    public func login(presenting viewController: UIViewController, permissions: Set<LoginPermission> = [.profile], completion: ((Result<UserProfile?, Error>) -> Void)?) {
                
        LoginManager.shared.login(permissions: permissions, in: viewController) { result in
            
            switch result {
            case .failure(let error): completion?(.failure(error))
            case .success(let info): completion?(.success(info.userProfile))
            }
        }
    }
    
    /// LINE圖示按鍵
    /// - Parameters:
    ///   - frame: CGRect
    ///   - viewController: UIViewController
    ///   - completion: Result<UserProfile?, Error>
    /// - Returns: Result<UserProfile?, Error>
    public func loginButton(with frame: CGRect = .zero, viewController: UIViewController, completion: ((Result<UserProfile?, Error>) -> Void)?) -> LoginButton {
        
        completionBlock = completion

        let button = LoginButton()
        
        button.delegate = self
        button.permissions = [.profile]
        button.presentingViewController = viewController
        
        return button
    }
    
    /// 在外部由URL Scheme開啟 -> application(_:open:options:)
    /// - Parameters:
    ///   - app: UIApplication
    ///   - url: URL
    ///   - options: [UIApplication.OpenURLOptionsKey: Any]
    /// - Returns: Bool
    public func canOpenURL(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return LoginManager.shared.application(application, open: url, options: options)
    }
    
    /// 在外部由UniversalLink開啟 -> application(_:continue:restorationHandler:)
    public func canOpenUniversalLink(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return LoginManager.shared.application(application, open: userActivity.webpageURL)
    }
}
