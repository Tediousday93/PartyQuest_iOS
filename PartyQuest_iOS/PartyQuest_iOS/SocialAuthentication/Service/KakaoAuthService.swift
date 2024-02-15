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
    func requestLogIn() -> Observable<Void> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map { _ in }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .map { _ in }
        }
    }
    
    func getSocialUserInfo() -> Observable<SocialUser> {
        return UserApi.shared.rx.me()
            .map { try $0.toDomain() }
            .asObservable()
    }
}
