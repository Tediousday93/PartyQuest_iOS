//
//  ServiceToken.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

struct ServiceToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiredTime: String
}
