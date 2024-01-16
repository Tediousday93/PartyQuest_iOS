//
//  UserDataUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

protocol UserDataUseCaseProvider {
    func makeKakaoSocialUserDataUseCase() -> SocialUserDataUseCase
    func makeGoogleSocialUserDataUseCase() -> SocialUserDataUseCase
    func makeNaverSocialUserDataUseCase() -> SocialUserDataUseCase
}
