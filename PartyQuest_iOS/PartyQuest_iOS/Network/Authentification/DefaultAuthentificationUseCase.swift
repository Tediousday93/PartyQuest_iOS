//
//  DefaultAuthentificationUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation

final class DefaultAuthentificationUseCase: AuthentificationUsecase {
    private let service: AuthentificationService
    
    init(service: AuthentificationService) {
        self.service = service
    }
    
    func logIn(email: String, password: String) {
        <#code#>
    }
    
    func signUp(email: String, password: String, nickname: String, birth: String) {
        <#code#>
    }
}
