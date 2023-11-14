//
//  DefaultAuthenticationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import RxSwift
import Moya

protocol AuthenticationService {
    func requestLogIn(email: String, password: String) -> Single<UserData>
    func requestSignUp(email: String, password: String, nickname: String, birth: String) -> Single<Void>
}

final class DefaultAuthenticationService: AuthenticationService {
    private let provider: MoyaProvider<AuthenticationAPI>
    
    init(provider: MoyaProvider<AuthenticationAPI>) {
        self.provider = provider
    }
    
    func requestLogIn(email: String, password: String) -> Single<UserData> {
        return provider.rx.request(.logIn(email: email,
                                          password: password))
        .filterSuccessfulStatusCodes()
        .map(LoginResponse.self)
        .map { $0.userData.first! }
    }
    
    func requestSignUp(email: String, password: String, nickname: String, birth: String) -> Single<Void> {
        return provider.rx.request(.signUp(email: email,
                                           password: password,
                                           nickname: nickname,
                                           birth: birth))
        .filter(statusCode: 201)
        .map { _ in }
    }
}
