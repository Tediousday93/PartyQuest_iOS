//
//  DefaultAuthentificationUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation
import RxSwift

final class DefaultAuthentificationUseCase: AuthentificationUseCase {
    private let service: AuthentificationService
    
    init(service: AuthentificationService) {
        self.service = service
    }
    
    func logIn(email: String, password: String) -> Single<UserData> {
        return service.requestLogIn(email: email, password: password)
    }
    
    func signUp(email: String, password: String, nickname: String, birth: String) -> Single<Void> {
        return service.requestSignUp(email: email,
                                     password: password,
                                     nickname: nickname,
                                     birth: birth)
    }
}
