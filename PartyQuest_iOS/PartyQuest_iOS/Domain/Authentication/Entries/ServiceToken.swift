//
//  ServiceToken.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/16.
//

struct ServiceToken: Codable {
    let accessExpiredAt: String
    let refreshExpiredAt: String
    let accessToken: String
    let refreshToken: String
    let email: String
}
