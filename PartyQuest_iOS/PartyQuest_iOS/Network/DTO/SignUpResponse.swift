//
//  SignUpResponse.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/22.
//

struct SignUpResponse: Decodable {
    let time, httpStatus: String
    let userInfo: [UserInfo]
    
    enum CodingKeys: String, CodingKey {
        case time
        case httpStatus
        case userInfo = "data"
    }
}

struct UserInfo: Decodable {
    let id: Int
    let email: String
}
