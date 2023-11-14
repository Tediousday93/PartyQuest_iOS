//
//  SocialAuthProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import Foundation

final class SocialAuthProvider {
    enum ServiceName {
        case kakao
    }
    
    func makeKakaoAuthService(name: ServiceName) -> any SocialAuthService {
        switch name {
        case .kakao:
            return KakaoAuthService()
        }
    }
}
