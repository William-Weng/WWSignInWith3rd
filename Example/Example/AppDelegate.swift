//
//  AppDelegate.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//

import UIKit
import WWSignInWith3rd

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        WWSignInWith3rd.Line.shared.configure(channelId: "<channelId>", channelSecret: "<channelSecret>", universalLinkURL: "<universalLinkURL>")
        WWSignInWith3rd.GitHub.shared.configure(clientId: "<clientId>", secret: "<secret>", callbackURL: "<callbackURL>", scope: "<scope>")
        WWSignInWith3rd.Twitter.shared.configure(apiKey: "<apiKey>", secret: "<secret>", accessToken: "<accessToken>", accessTokenSecret: "<accessTokenSecret>")

        return true
    }
}

// MARK: - 相關設定
extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        _ = WWSignInWith3rd.Twitter.shared.canOpenURL(app, open: url, options: options)
        _ = WWSignInWith3rd.Line.shared.canOpenURL(app, open: url, options: options)

        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
                
        _ = WWSignInWith3rd.Line.shared.canOpenUniversalLink(application, continue: userActivity, restorationHandler: restorationHandler)

        return true
    }
}
