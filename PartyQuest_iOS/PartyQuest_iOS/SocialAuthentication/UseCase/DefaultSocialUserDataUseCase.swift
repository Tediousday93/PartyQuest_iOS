//
//  DefaultSocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/13.
//

import RxSwift

final class DefaultSocialUserDataUseCase<Service: SocialAuthService>: SocialUserDataUseCase where Service.UserInfo.Domain == SocialLogInRequestModel {
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func logIn() -> Observable<Void> {
        return service.requestLogIn()
            .map { _ in }
    }
    
    func socialUserData() -> Observable<SocialLogInRequestModel> {
        return service.getUserInfo()
            .map { $0.toDomain() }
    }
}
