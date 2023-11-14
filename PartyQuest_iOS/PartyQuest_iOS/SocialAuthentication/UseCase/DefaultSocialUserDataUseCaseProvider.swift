//
//  DefaultSocialUserDataUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

final class DefaultSocialUserDataUseCaseProvider: SocialUserDataUseCaseProvider {
    private let serviceProvider: SocialAuthProvider
    
    init(serviceProvider: SocialAuthProvider) {
        self.serviceProvider = serviceProvider
    }
    
    func makeDefaultSocialUserDataUseCase() -> SocialUserDataUseCase {
        let kakaoAuthService = serviceProvider.makeKakaoAuthService()
        let kakaoAuthRepository = SocialUserDataRepository(service: kakaoAuthService)
        
        return DefaultSocialUserDataUseCase(kakaoAuthRepository: kakaoAuthRepository)
    }
}
