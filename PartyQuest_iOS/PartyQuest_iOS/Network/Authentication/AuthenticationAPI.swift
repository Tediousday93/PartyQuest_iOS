//
//  AuthenticationAPI.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation
import Moya

enum AuthenticationAPI {
    case logIn(email: String, password: String)
    case signUp(email: String, password: String, nickname: String, birth: String)
    case kakao(requestData: SocialLogInRequestModel)
}

extension AuthenticationAPI: TargetType {
    var baseURL: URL {
        URL(string: Bundle.main.baseURL)!
    }
    
    var path: String {
        switch self {
        case .logIn:
            return "auth/login"
        case .signUp:
            return "auth/signup"
        case .kakao:
            return "login/oauth/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logIn:
            return .post
        case .signUp:
            return .post
        case .kakao:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logIn(let email, let password):
            let parameters = [
                "email": email,
                "password": password
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        case .signUp(let email, let password, let nickname, let birth):
            let parameters = [
                "email": email,
                "password": password,
                "nickname": nickname,
                "birth": birth
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        case .kakao(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
