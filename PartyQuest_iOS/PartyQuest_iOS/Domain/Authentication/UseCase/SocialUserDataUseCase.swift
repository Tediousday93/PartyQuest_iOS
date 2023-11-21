//
//  SocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift

protocol SocialUserDataUseCase {
    func logIn() -> Observable<Result<Void, Error>>
    func socialUserData() -> Observable<SocialUserData>
}
