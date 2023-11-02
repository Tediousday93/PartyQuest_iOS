//
//  DefaultAuthentificationService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation
import Moya

final class DefaultAuthentificationService: AuthentificationService {
    private let provider: MoyaProvider<AuthentificationAPI>
    
    init(provider: MoyaProvider<AuthentificationAPI>) {
        self.provider = provider
    }
    
    func requestLogIn(email: String, password: String) {
        provider.request(.logIn(email: email, password: password)) { result in
            <#code#>
        }
    }
    
    func requestSignUp(email: String, password: String, nickname: String, birth: String) {
        <#code#>
    }
}
