//
//  DomainConvertibleType.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import KakaoSDKUser
import GoogleSignIn

enum DomainConvertError: Error {
    case nilSocialUserData
}

protocol DomainConvertibleType {
    associatedtype Domain
    
    func toDomain() throws -> Domain
}

extension KakaoSDKUser.User: DomainConvertibleType {
    typealias Domain = SocialUser
    
    func toDomain() throws -> SocialUser {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key")
        }
        
        guard let email = kakaoAccount?.email,
              let nickname = properties?["nickname"] else {
            throw DomainConvertError.nilSocialUserData
        }
        
        return SocialUser(
            email: email,
            nickname: nickname
        )
    }
}

extension GIDGoogleUser: DomainConvertibleType {
    typealias Domain = SocialUser
    
    func toDomain() throws -> SocialUser {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key ")
        }
        
        guard let email = profile?.email,
              let nickname = profile?.name else {
            throw DomainConvertError.nilSocialUserData
        }
        
        return SocialUser(
            email: email,
            nickname: nickname
        )
    }
}

extension NaverUserData: DomainConvertibleType {
    typealias Domain = SocialUser
    
    func toDomain() throws -> SocialUser {
        guard let secrets = Bundle.main.infoDictionary?["SERVICE_SECRETS"] as? String else {
            fatalError("Can not find Secrets Key")
        }
        
        guard let email = email,
              let nickname = nickname else {
            throw DomainConvertError.nilSocialUserData
        }
        
        return SocialUser(
            email: email,
            nickname: nickname
        )
    }
}

