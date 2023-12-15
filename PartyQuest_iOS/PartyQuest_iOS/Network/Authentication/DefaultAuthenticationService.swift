//
//  DefaultAuthenticationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import RxSwift
import Moya

protocol AuthenticationService {
    func requestLogIn(email: String, password: String) -> Single<LogInResponse>
    func requestSignUp(email: String, password: String, nickname: String) -> Single<SignUpResponse>
    func requestKakaoLogIn(email: String, secrets: String, nickName: String) -> Single<LogInResponse>
}

final class DefaultAuthenticationService: AuthenticationService {
    private let provider: MoyaProvider<AuthenticationAPI>
    
    init(provider: MoyaProvider<AuthenticationAPI>) {
        self.provider = provider
    }
    
    func requestLogIn(email: String, password: String) -> Single<LogInResponse> {
        return provider.rx.request(.logIn(email: email,
                                          password: password))
        .filterSuccessfulStatusCodes()
        .map(LogInResponse.self)
    }
    
    func requestSignUp(email: String, password: String, nickname: String) -> Single<SignUpResponse> {
        return provider.rx.request(.signUp(email: email,
                                           password: password,
                                           nickname: nickname))
        .filterSuccessfulStatusCodes()
        .map(SignUpResponse.self)
    }
    
    func requestKakaoLogIn(email: String, secrets: String, nickName: String) -> Single<LogInResponse> {
        return provider.rx.request(.kakao(email: email,
                                          secrets: secrets,
                                          nickName: nickName))
        .filterSuccessfulStatusCodes()
        .map(LogInResponse.self)
    }
}
