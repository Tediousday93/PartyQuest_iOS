//
//  NaverUserDataResponse.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/05.
//

struct NaverUserDataResponse: Decodable {
    let resultcode, message: String
    let userData: NaverUserData
    
    enum CodingKeys: String, CodingKey {
        case resultcode, message
        case userData = "response"
    }
}

struct NaverUserData: Decodable {
    let email, nickname: String?
    let profileImage: String?
    let age, gender, id, name: String?
    let birthday, birthyear, mobile: String?

    enum CodingKeys: String, CodingKey {
        case email, nickname
        case profileImage = "profile_image"
        case age, gender, id, name, birthday, birthyear, mobile
    }
}
