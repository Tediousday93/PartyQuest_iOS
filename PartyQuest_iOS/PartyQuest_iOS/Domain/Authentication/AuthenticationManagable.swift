//
//  AuthenticationManagable.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

import RxSwift

protocol AuthenticationManagable {
    func signUp(userData: UserData) -> Single<Void>
    func logIn(userData: UserData) -> Single<[ServiceToken]>
}
