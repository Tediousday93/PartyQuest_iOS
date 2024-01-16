//
//  UserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift

protocol UserDataUseCase {
    func getUserData(for platform: LogInPlatform) -> Observable<UserData>
}
