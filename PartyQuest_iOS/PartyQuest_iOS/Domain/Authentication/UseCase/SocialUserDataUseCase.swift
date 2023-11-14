//
//  SocialUserDataUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import Foundation
import RxSwift

protocol SocialUserDataUseCase {
    func kakaoSocialUserData() -> Single<SocialUserData>
}
