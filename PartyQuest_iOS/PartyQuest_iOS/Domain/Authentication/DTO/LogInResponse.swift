//
//  UserData.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

struct LogInResponse: Decodable {
    let time: String
    let httpStatus: String
    let tokenData: [ServiceToken]
    
    enum CodingKeys: String, CodingKey {
        case time
        case httpStatus
        case tokenData = "data"
    }
}

struct ServiceToken: Codable {
    let accessExpiredAt: String
    let refreshExpiredAt: String
    let accessToken: String
    let refreshToken: String
    let email: String
}
