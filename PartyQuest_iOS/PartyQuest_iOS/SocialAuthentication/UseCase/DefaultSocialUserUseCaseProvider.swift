//
//  DefaultSocialUserUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

final class DefaultSocialUserUseCaseProvider: SocialUserUseCaseProvider {
    private let serviceProvider: SocialAuthProvider
    
    init() {
        self.serviceProvider = SocialAuthProvider()
    }
    
    func makeSocialUserUseCase() -> SocialUserUseCase {
        return DefaultSocialUserUseCase(kakaoAuthService: serviceProvider.makeKakaoAuthService(),
                                      googleAuthService: serviceProvider.makeGoogleAuthService(),
                                      naverAuthService: serviceProvider.makeNaverAuthService())
    }
}
