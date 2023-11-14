//
//  DefaultSocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

final class DefaultSocialUserDataUseCase: SocialUserDataUseCase {
    private let kakaoAuthRepository: SocialUserDataRepository<KakaoAuthService>
    
    init(kakaoAuthRepository: SocialUserDataRepository<KakaoAuthService>) {
        self.kakaoAuthRepository = kakaoAuthRepository
    }
    
    func kakaoSocialUserData() -> Single<SocialUserData> {
        return kakaoAuthRepository.getSocialUserData()
    }
}
