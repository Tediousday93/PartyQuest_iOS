//
//  KakaoAuthService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

final class KakaoAuthService: SocialAuthService {
    typealias UserInfo = User
    
    func requestLogIn() -> Observable<UserInfo> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .flatMap { _ in
                    UserApi.shared.rx.me()
                }
                .asObservable()
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .flatMap { _ in
                    UserApi.shared.rx.me()
                }
                .asObservable()
        }
    }
}
