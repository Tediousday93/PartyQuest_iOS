//
//  DomainConvertibleType.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import Foundation
import KakaoSDKUser

protocol DomainConvertibleType {
    associatedtype Domain
    
    func toDomain() -> Domain
}

extension KakaoSDKUser.User: DomainConvertibleType {
    typealias Domain = SocialUserData
    
    func toDomain() -> SocialUserData {
        return SocialUserData(id: String(describing: id),
                        email: kakaoAccount?.email,
                        nickName: properties?["nickname"],
                        platform: "Kakao")
    }
}
