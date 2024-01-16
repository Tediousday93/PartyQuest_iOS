//
//  SocialUserData.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

struct UserData {
    var email: String?
    var secrets: String?
    var nickName: String?
    var platform: LogInPlatform
    var serviceToken: ServiceToken?
}

enum LogInPlatform {
    case partyQuest
    case kakao
    case apple
    case google
    case naver
}
