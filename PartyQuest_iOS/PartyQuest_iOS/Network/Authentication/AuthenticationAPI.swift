//
//  AuthenticationAPI.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation
import Moya

enum AuthenticationAPI {
    case logIn(email: String, password: String, platform: String)
    case signUp(email: String, password: String, nickname: String)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logIn:
            return .post
        case .signUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logIn(let email, let password, let platform):
            let parameters = [
                "email": email,
                "password": password,
                "platform": platform
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case .signUp(let email, let password, let nickname):
            let parameters = [
                "email": email,
                "password": password,
                "nickname": nickname,
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
