//
//  SocialAuthProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

final class SocialAuthProvider {
    func makeKakaoAuthService() -> KakaoAuthService {
        return KakaoAuthService()        
    }
    
    func makeGoogleAuthService() -> GoogleAuthService {
        return GoogleAuthService()
    }
    
    func makeNaverAuthService() -> NaverAuthService {
        return NaverAuthService()
    }
}
