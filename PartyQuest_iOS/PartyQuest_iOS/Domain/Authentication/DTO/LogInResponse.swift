//
//  UserData.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/02.
//

struct LoginResponse: Decodable {
    let time: String
    let httpStatus: String
    let serviceToken: [ServiceToken]
    
    enum CodingKeys: String, CodingKey {
        case time
        case httpStatus
        case serviceToken = "data"
    }
}

struct ServiceToken: Equatable, Decodable {
    let accessToken: String
    let refreshToken: String
    let email: String
}
