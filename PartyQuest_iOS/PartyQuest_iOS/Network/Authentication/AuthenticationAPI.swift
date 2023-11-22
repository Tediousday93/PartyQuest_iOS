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
    case signUp(email: String, password: String, nickname: String)
    case kakao(email: String?, secrets: String, nickName: String?)
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
            return "auth/login/oauth/kakao"
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
                                      encoding: JSONEncoding.default)
        case .signUp(let email, let password, let nickname):
            let parameters = [
                "email": email,
                "password": password,
                "nickname": nickname,
            ]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case .kakao(let email, let secrets, let nickName):
            let parameters = [
                "email": email,
                "secrets": secrets,
                "nickname": nickName
            ]
            return .requestParameters(parameters: parameters as [String : Any],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
