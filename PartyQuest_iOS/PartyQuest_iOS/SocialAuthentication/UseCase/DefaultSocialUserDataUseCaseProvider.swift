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
    
    func makeKakaoSocialUserDataUseCase() -> SocialUserDataUseCase {
        return DefaultSocialUserDataUseCase(
            service: serviceProvider.makeKakaoAuthService()
        )
    }
}
