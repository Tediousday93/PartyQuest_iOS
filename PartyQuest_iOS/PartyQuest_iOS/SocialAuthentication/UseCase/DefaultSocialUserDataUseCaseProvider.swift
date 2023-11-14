//
//  DefaultSocialUserDataUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

final class DefaultSocialUserDataUseCaseProvider: SocialUserDataUseCaseProvider {
    private let serviceProvider: SocialAuthProvider
    
    init() {
        self.serviceProvider = SocialAuthProvider()
    }
    
    func makeKakaoSocialUserDataUseCase() -> SocialUserDataUseCase {
        return DefaultSocialUserDataUseCase(
            service: serviceProvider.makeKakaoAuthService()
        )
    }
}