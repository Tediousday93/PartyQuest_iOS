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
    
    func signUp(userData: UserData) -> Single<Void> {
        guard let email = userData.email,
              let secrets = userData.secrets,
              let nickname = userData.nickName
        else { return Single.error(PQUserDataError.insufficientData) }
        
        return service.requestSignUp(email: email,
                                     password: secrets,
                                     nickname: nickname)
    }
    
    func logIn(userData: UserData) -> Single<[ServiceToken]> {
        guard let email = userData.email,
              let secrets = userData.secrets,
              let nickname = userData.nickName
        else { return Single.error(PQUserDataError.insufficientData) }
        
        return service.requestLogIn(email: email,
                                    secrets: secrets,
                                    nickName: nickname,
                                    platform: userData.platform)
        .map { $0.tokenData }
    }
}

enum PQUserDataError: Error {
    case insufficientData
}
