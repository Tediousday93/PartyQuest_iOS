//
//  PQAuthenticationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import RxSwift
import Moya

protocol AuthenticationService {
    func requestSignUp(email: String, password: String, nickname: String) -> Single<Void>
    func requestLogIn(email: String, secrets: String, nickName: String, platform: LogInPlatform?) -> Single<LogInResponse>
}

final class PQAuthenticationService: AuthenticationService {
    private let provider: MoyaProvider<AuthenticationAPI>
    
    init(provider: MoyaProvider<AuthenticationAPI>) {
        self.provider = provider
    }
    
    func requestSignUp(email: String, password: String, nickname: String) -> Single<Void> {
        return provider.rx.request(.signUp(email: email, password: password, nickname: nickname))
            .map { response in
                switch response.statusCode {
                case 200..<300:
                    guard let jsonData = try response.mapJSON(failsOnEmptyData: true) as? Data
                    else {
                        throw AuthenticationError.decodingFailure
                    }
                    
                    _ = try JSONDecoder().decode(SignUpResponse.self, from: jsonData)
                    
                    return
                case 409:
                    guard let jsonData = try response.mapJSON(failsOnEmptyData: true) as? Data
                    else {
                        throw AuthenticationError.decodingFailure
                    }
                    
                    let decoded = try JSONDecoder().decode(SignUpErrorResponse.self, from: jsonData)
                    
                    throw AuthenticationError.emailDuplication(serverMessage: decoded.message)
                default:
                    throw AuthenticationError.serverError
                }
            }
    }
    
    func requestLogIn(
        email: String,
        secrets: String,
        nickName: String,
        platform: LogInPlatform?
    ) -> Single<LogInResponse> {
        switch platform {
        case .kakao:
            return requestKakaoLogIn(email: email, secrets: secrets, nickName: nickName)
        default:
            return requestPQLogIn(email: email, secrets: secrets)
        }
    }
    
    private func requestPQLogIn(email: String, secrets: String) -> Single<LogInResponse> {
        return provider.rx.request(.logIn(email: email,
                                          password: secrets))
        .filterSuccessfulStatusCodes()
        .map(LogInResponse.self)
    }
    
    private func requestKakaoLogIn(
        email: String,
        secrets: String,
        nickName: String
    ) -> Single<LogInResponse> {
        return provider.rx.request(.kakao(email: email,
                                          secrets: secrets,
                                          nickName: nickName))
        .filterSuccessfulStatusCodes()
        .map(LogInResponse.self)
    }
}

enum AuthenticationError: Error {
    case decodingFailure
    case emailDuplication(serverMessage: String)
    case serverError
}
