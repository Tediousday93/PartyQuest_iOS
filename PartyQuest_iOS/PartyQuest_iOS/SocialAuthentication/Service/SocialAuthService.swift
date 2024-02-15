//
//  SocialAuthService.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

protocol SocialAuthService {
    func requestLogIn() -> Observable<Void>
    func getSocialUserInfo() -> Observable<SocialUser>
}
