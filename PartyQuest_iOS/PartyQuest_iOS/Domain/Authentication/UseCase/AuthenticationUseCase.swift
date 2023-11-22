//
//  AuthenticationUsecase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

import RxSwift

protocol AuthenticationUseCase {
    func logIn(email: String, password: String) -> Single<ServiceToken>
    func signUp(email: String, password: String, nickname: String) -> Single<SignUpResponse>
    func socialLogIn(requestModel: SocialLogInRequestModel) -> Single<ServiceToken>
}
