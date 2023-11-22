//
//  DefaultAuthenticationUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import RxSwift

final class DefaultAuthenticationUseCase: AuthenticationUseCase {
    private let service: AuthenticationService
    
    init(service: AuthenticationService) {
        self.service = service
    }
    
    func logIn(email: String, password: String) -> Single<ServiceToken> {
        return service.requestLogIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String, nickname: String) -> Single<SignUpResponse> {
        return service.requestSignUp(email: email,
                                     password: password,
                                     nickname: nickname)
    }
    
    func socialLogIn(requestModel: SocialLogInRequestModel) -> Single<ServiceToken> {
        guard let email = requestModel.email,
              let secrets = requestModel.secrets,
              let nickName = requestModel.nickName else {
            return Single.error(AuthenticationError.nilData)
        }
    
        switch requestModel.platform {
        case .kakao:
            return service.requestKakaoLogIn(email: email,
                                             secrets: secrets,
                                             nickName: nickName)
        default:
            fatalError()
        }
    }
}

enum AuthenticationError: Error {
    case nilData
}
