//
//  SignInWith3rd+Twitter.swift
//  SignInWith3rd
//
//  Created by William.Weng on 2021/8/11.
//

import Swifter
import AuthenticationServices

// MARK: - 第三方登入
extension WWSignInWith3rd {
            
    /// [推特SDK整合 Swifter - 2.5.0](https://github.com/mattdonnelly/Swifter)
    open class Twitter: NSObject {
        
        public static let shared = Twitter()
        
        private(set) var apiKey: String?
        private(set) var secret: String?
        private(set) var bearerToken: String?
        private(set) var callbackURL: String?
        private(set) var accessToken: String?
        private(set) var accessTokenSecret: String?

        private let TwitterAuthUrl = "twitterauth://"
        private var swifter: Swifter?
        
        private override init() {}
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
@available(iOS 13.0, *)
extension WWSignInWith3rd.Twitter: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIWindow._keyWindow() ?? UIWindow()
    }
}

// MARK: - SignInWithTwitter
extension WWSignInWith3rd.Twitter {
    
    /// [參數設定 => 3-legged OAuth is enabled](https://developer.twitter.com/en/apps)
    /// - Parameters:
    ///   - apiKey: [API Key](https://developer.twitter.com/en/portal/register/keys)
    ///   - secret: [API Secret Key](https://github.com/twitter-archive/twitter-kit-ios)
    ///   - callbackURL: [要彈回App的Scheme - swifter-<API_Key>://](https://developer.twitter.com/en/portal/projects)
    /// - Returns: [Bool](https://medium.com/flawless-app-stories/twitter-login-with-swiftui-e7e2f12680d6)
    public func configure(apiKey: String, secret: String, accessToken: String, accessTokenSecret: String, callbackURL: String? = nil) {
        
        self.apiKey = apiKey
        self.secret = secret
        self.callbackURL = callbackURL ?? "swifter-\(apiKey)://"
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
        
        self.swifter = Swifter(consumerKey: apiKey, consumerSecret: secret, appOnly: true)
        
        // self.swifter = Swifter(consumerKey: apiKey, consumerSecret: secret, oauthToken: accessToken, oauthTokenSecret: accessTokenSecret)
    }
    
    /// [登入](https://developer.twitter.com/en/docs/authentication/overview)
    /// - Parameters:
    ///   - viewController: [UIViewController](https://developer.twitter.com/en/docs/authentication/api-reference)
    ///   - completion: [Result<Credential.OAuthAccessToken?, Error>](https://iag.me/socialmedia/how-to-create-a-twitter-app-in-8-easy-steps/)
    public func login(presenting viewController: UIViewController, completion: ((Result<Credential.OAuthAccessToken?, Error>) -> Void)?) {

        guard let url = URL(string: TwitterAuthUrl),
              UIApplication.shared.canOpenURL(url)
        else {
            loginWithWeb(presenting: viewController, completion: completion); return
        }
        
        loginWithSSO(completion: completion)
    }
    
    /// [使用APP登入 - SSO](https://zh.wikipedia.org/wiki/單一登入)
    /// - Parameter completion: [Result<Credential.OAuthAccessToken?, Error>](https://www.jianshu.com/p/eb588377e14e)
    public func loginWithSSO(completion: ((Result<Credential.OAuthAccessToken?, Error>) -> Void)?) {
        
        guard let swifter = swifter else { return }
        
        swifter.authorizeSSO { token in
            completion?(.success(token))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// [使用WebView登入](https://developer.twitter.com/en/docs/authentication/overview)
    /// - Parameters:
    ///   - viewController: [UIViewController](https://developer.twitter.com/en/docs/authentication/api-reference)
    ///   - completion: [Result<Credential.OAuthAccessToken?, Error>](https://iag.me/socialmedia/how-to-create-a-twitter-app-in-8-easy-steps/)
    public func loginWithWeb(presenting viewController: UIViewController, completion: ((Result<Credential.OAuthAccessToken?, Error>) -> Void)?) {
        
        guard let swifter = swifter,
              let callbackURL = callbackURL,
              let callbackUrl = URL(string: callbackURL)
        else {
            completion?(.failure(Constant.MyError.unregistered)); return
        }
        
        if #available(iOS 13.0, *) {
            swifter.authorize(withProvider: self, callbackURL: callbackUrl) { token, response in
                completion?(.success(token))
            } failure: { error in
                completion?(.failure(error))
            }; return
        }
        
        swifter.authorize(withCallback: callbackUrl, presentingFrom: viewController) { token, response in
            completion?(.success(token))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// [在外部由URL Scheme開啟 -> application(_:open:options:)](https://www.hangge.com/blog/cache/detail_1042.html)
    /// - Parameters:
    ///   - app: [UIApplication](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Launching_a_Mini_Program/iOS_Development_example.html)
    ///   - url: [URL](https://www.ctolib.com/topics-132328.html)
    ///   - options: [[UIApplication.OpenURLOptionsKey: Any]](https://www.appcoda.com.tw/ios-oauth/)
    /// - Returns: [Bool](https://www.imtqy.com/MiniProgram-navigate.html)
    public func canOpenURL(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        guard let callbackUrlString = callbackURL,
              let callbackURL = URL(string: callbackUrlString)
        else {
            return false
        }
        
        return Swifter.handleOpenURL(url, callbackURL: callbackURL)
    }
}
