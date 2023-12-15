//
//  SceneDelegate.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/26.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import GoogleSignIn
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            } else if (GIDSignIn.sharedInstance.handle(url)) {
                
            } else if isNaverLoginUrl(url) {
                NaverThirdPartyLoginConnection
                    .getSharedInstance()
                    .receiveAccessToken(url)
            }
        }
    }
    
    private func isNaverLoginUrl(_ url: URL) -> Bool {
        let scheme = url.scheme
        let naverScheme = Bundle.main.infoDictionary?["NAVER_URL_SCHEME"] as? String
        
        return scheme == naverScheme
    }
}

