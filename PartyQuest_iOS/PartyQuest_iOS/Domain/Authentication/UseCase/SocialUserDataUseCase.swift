//
//  SocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift

protocol SocialUserDataUseCase {
    func logIn() -> Observable<Void>
    func socialUserData() -> Observable<SocialLogInRequestModel>
}
