//
//  SocialLogInRequestModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

struct SocialLogInRequestModel {
    var email: String?
    var secrets: String?
    var nickName: String?
    var platform: Platform
}

enum Platform {
    case kakao
    case apple
    case google
    case naver
}
