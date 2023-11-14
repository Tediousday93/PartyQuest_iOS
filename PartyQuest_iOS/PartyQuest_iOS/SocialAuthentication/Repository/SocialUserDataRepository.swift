//
//  SocialUserDataRepository.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift
import KakaoSDKUser

final class SocialUserDataRepository<Service: SocialAuthService> where Service.UserInfo.Domain == SocialUserData {
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func getSocialUserData() -> Single<SocialUserData> {
        return service.requestLogIn()
            .map { user in
                user.toDomain()
            }
    }
}
