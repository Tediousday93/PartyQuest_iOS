//
//  SocialUserData.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

struct SocialUserData {
    var email: String?
    var secrets: String?
    var nickName: String?
    var platform: LogInPlatform
}

enum LogInPlatform {
    case kakao
    case apple
    case google
    case naver
}
