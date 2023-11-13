//
//  AuthenticationUsecase.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

import Foundation
import RxSwift

protocol AuthenticationUseCase {
    func logIn(email: String, password: String) -> Single<UserData>
    func signUp(email: String, password: String, nickname: String, birth: String) -> Single<Void>
}
