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
    
    func logIn() -> Observable<Result<Void, Error>> {
        return service.requestLogIn()
            .map { _ in
                Result<Void, Error>.success(())
            }
            .catch { error in
                Observable.just(Result<Void, Error>.failure(error))
            }
    }
    
    func socialUserData() -> Observable<SocialUserData> {
        return service.getUserInfo()
            .map { $0.toDomain() }
    }
}
