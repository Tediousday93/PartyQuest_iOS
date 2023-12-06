//
//  SocialUserDataUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

protocol SocialUserDataUseCaseProvider {
    func makeKakaoSocialUserDataUseCase() -> SocialUserDataUseCase
    func makeNaverSocialUserDataUseCase() -> SocialUserDataUseCase
}
