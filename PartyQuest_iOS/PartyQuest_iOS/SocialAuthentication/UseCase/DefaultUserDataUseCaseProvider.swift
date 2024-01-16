//
//  DefaultSocialUserDataUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

final class DefaultUserDataUseCaseProvider: UserDataUseCaseProvider {
    private let serviceProvider: SocialAuthProvider
    
    init() {
        self.serviceProvider = SocialAuthProvider()
    }
    
    func makeUserDataUseCase() -> UserDataUseCase {
        return DefaultUserDataUseCase(kakaoAuthService: serviceProvider.makeKakaoAuthService(),
                                      googleAuthService: serviceProvider.makeGoogleAuthService(),
                                      naverAuthService: serviceProvider.makeNaverAuthService())
    }
}
