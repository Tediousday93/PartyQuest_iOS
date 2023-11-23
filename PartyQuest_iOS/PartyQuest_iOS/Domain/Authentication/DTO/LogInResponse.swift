//
//  UserData.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

struct LogInResponse: Decodable {
    let time: String
    let httpStatus: String
    let tokenData: [TokenData]
    
    enum CodingKeys: String, CodingKey {
        case time
        case httpStatus
        case tokenData = "data"
    }
}

struct TokenData: Decodable {
    let accessToken: String
    let refreshToken: String
    let email: String
}
