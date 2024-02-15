//
//  DefaultSocialUserUseCase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

final class DefaultSocialUserUseCase: SocialUserUseCase {
    private let kakaoAuthService: SocialAuthService
    private let googleAuthService: SocialAuthService
    private let naverAuthService: SocialAuthService
    
    init(kakaoAuthService: SocialAuthService,
         googleAuthService: SocialAuthService,
         naverAuthService: SocialAuthService) {
        self.kakaoAuthService = kakaoAuthService
        self.googleAuthService = googleAuthService
        self.naverAuthService = naverAuthService
    }
    
    func getSocialUser(for platform: LogInPlatform) -> Observable<SocialUser> {
        let service = getService(for: platform)
        
        return service.requestLogIn()
            .materialize()
            .filter { $0.error == nil }
            .flatMap { _ in
                service.getSocialUserInfo()
            }
    }
    
    private func getService(for platform : LogInPlatform) -> SocialAuthService {
        switch platform {
        case .kakao:
            return kakaoAuthService
        case .google:
            return googleAuthService
        case .naver:
            return naverAuthService
        default:
            fatalError("Unsupported social platform: \(platform.rawValue)")
        }
    }
}
