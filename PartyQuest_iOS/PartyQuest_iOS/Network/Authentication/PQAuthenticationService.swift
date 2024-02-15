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
    func requestLogIn(email: String, password: String, platform: LogInPlatform) -> Single<PQUser>
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
        password: String,
        platform: LogInPlatform
    ) -> Single<PQUser> {
        return provider.rx.request(.logIn(email: email,
                                          password: password,
                                          platform: platform.rawValue))
        .filterSuccessfulStatusCodes()
        .map(PQUser.self)
    }
}

enum AuthenticationError: Error {
    case decodingFailure
    case emailDuplication(serverMessage: String)
    case serverError
}
