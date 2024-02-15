//
//  AuthenticationManagable.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

import RxSwift

protocol AuthenticationManagable {
    func signUp(email: String, password: String, nickname: String) -> Single<Void>
    func logIn(email: String, password: String?, platform: LogInPlatform) -> Single<PQUser>
}
