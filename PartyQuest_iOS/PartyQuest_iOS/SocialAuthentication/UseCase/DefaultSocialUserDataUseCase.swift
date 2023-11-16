//
//  DefaultSocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

final class DefaultSocialUserDataUseCase<Service: SocialAuthService>: SocialUserDataUseCase where Service.UserInfo.Domain == SocialUserData {
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func socialUserData() -> Observable<SocialUserData> {
        return service.requestLogIn()
            .map { $0.toDomain() }
    }
}
