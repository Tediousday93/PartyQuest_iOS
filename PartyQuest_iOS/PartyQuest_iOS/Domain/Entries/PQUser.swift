//
//  PQUser.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

struct PQUser: Codable {
    let id: UInt64
    let profile: Profile
    let logInPlatform: LogInPlatform
    let serviceToken: ServiceToken
}

struct Profile: Codable {
    let email: String
    let nickname: String
    let imageName: String
}

enum LogInPlatform: String, Codable {
    case partyQuest
    case apple
    case kakao
    case google
    case naver
}

struct ServiceToken: Codable {
    let accessExpiredAt: String
    let refreshExpiredAt: String
    let accessToken: String
    let refreshToken: String
}
