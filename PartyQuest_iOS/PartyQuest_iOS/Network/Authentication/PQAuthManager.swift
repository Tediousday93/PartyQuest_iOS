//
//  DefaultAuthenticationUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import RxSwift

final class PQAuthManager: AuthenticationManagable {
    private let service: AuthenticationService
    
    init(service: AuthenticationService) {
        self.service = service
    }
    
    func signUp(email: String, password: String, nickname: String) -> Single<Void> {
        return service.requestSignUp(
            email: email,
            password: password,
            nickname: nickname
        )
    }
    
    func logIn(email: String, password: String?, platform: LogInPlatform) -> Single<PQUser> {
        return service.requestLogIn(
            email: email,
            password: password ?? Bundle.main.serviceSecrets,
            platform: platform
        )
    }
}
