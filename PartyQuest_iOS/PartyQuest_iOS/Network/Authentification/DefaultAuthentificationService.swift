//
//  DefaultAuthentificationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation
import RxSwift
import Moya

protocol AuthentificationService {
    func requestLogIn(email: String, password: String) -> Single<UserData>
    func requestSignUp(email: String, password: String, nickname: String, birth: String) -> Single<UserData>
}

final class DefaultAuthentificationService: AuthentificationService {
    private let provider: MoyaProvider<AuthentificationAPI>
    
    init(provider: MoyaProvider<AuthentificationAPI>) {
        self.provider = provider
    }
    
    func requestLogIn(email: String, password: String) -> Single<UserData> {
        return provider.rx.request(.logIn(email: email,
                                          password: password))
        .filterSuccessfulStatusCodes()
        .map(UserData.self)
    }
    
    func requestSignUp(email: String, password: String, nickname: String, birth: String) -> Single<UserData> {
        return provider.rx.request(.signUp(email: email,
                                           password: password,
                                           nickname: nickname,
                                           birth: birth))
        .filterSuccessfulStatusCodes()
        .map(UserData.self)
    }
}
