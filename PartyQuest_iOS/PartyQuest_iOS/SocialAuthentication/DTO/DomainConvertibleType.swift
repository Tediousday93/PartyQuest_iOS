//
//  DomainConvertibleType.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import KakaoSDKUser
import GoogleSignIn

protocol DomainConvertibleType {
    associatedtype Domain
    
    func toDomain() -> Domain
}

extension KakaoSDKUser.User: DomainConvertibleType {
    typealias Domain = UserData
    
    func toDomain() -> UserData {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key")
        }
        
        return UserData(
            email: kakaoAccount?.email,
            secrets: secrets,
            nickName: properties?["nickname"],
            platform: .kakao
        )
    }
}

extension GIDGoogleUser: DomainConvertibleType {
    typealias Domain = UserData
    
    func toDomain() -> UserData {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key ")
        }
        
        return UserData(email: profile?.email,
                              secrets: secrets,
                              nickName: profile?.name,
                              platform: .google)
    }
}

extension NaverUserData: DomainConvertibleType {
    typealias Domain = UserData
    
    func toDomain() -> UserData {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key")
        }
        
        return UserData(
            email: email,
            secrets: secrets,
            nickName: nickName,
            platform: .naver
        )
    }
}

