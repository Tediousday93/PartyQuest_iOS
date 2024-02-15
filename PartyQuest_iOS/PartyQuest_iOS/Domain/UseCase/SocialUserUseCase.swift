//
//  SocialUserUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift

protocol SocialUserUseCase {
    func getSocialUser(for platform: LogInPlatform) -> Observable<SocialUser>
}
