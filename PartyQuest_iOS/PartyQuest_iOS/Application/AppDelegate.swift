//
//  AppDelegate.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/26.
//

import UIKit
import RxKakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        RxKakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        initNaverSDK()
        
        return true
    }
    
    private func initNaverSDK() {
        let naverUrlScheme = Bundle.main.infoDictionary?["NAVER_URL_SCHEME"] as? String
        let naverClientID = Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as? String
        let naverClientSecret = Bundle.main.infoDictionary?["NAVER_CLIENT_SECRET"] as? String
        let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        naverConnection?.isNaverAppOauthEnable = true
        naverConnection?.isInAppOauthEnable = true
        naverConnection?.setOnlyPortraitSupportInIphone(true)
        naverConnection?.serviceUrlScheme = naverUrlScheme
        naverConnection?.consumerKey = naverClientID
        naverConnection?.consumerSecret = naverClientSecret
        naverConnection?.appName = "PartyQuest"
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

