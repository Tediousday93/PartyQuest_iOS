//
//  SocialAuthService.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

protocol SocialAuthService {
    associatedtype SocialUserInfo: DomainConvertibleType
    
    func requestLogIn() -> Observable<Void>
    func getUserInfo() -> Observable<SocialUserInfo>
}
