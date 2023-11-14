//
//  KakaoAuthService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import Foundation
import RxSwift
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

final class KakaoAuthService: SocialAuthService {
    typealias UserInfo = User
    
    func requestLogIn() -> Single<UserInfo> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .asSingle()
                .flatMap { token in
                    UserApi.shared.rx.me()
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .asSingle()
                .flatMap { token in
                    UserApi.shared.rx.me()
                }
        }
    }
}
