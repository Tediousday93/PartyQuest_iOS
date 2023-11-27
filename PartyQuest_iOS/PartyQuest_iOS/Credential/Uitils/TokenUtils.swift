//
//  TokenUtils.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import Foundation

final class TokenUtils {
    static let shared = TokenUtils()
    private let useCase: ServiceTokenUseCase
    
    private init() {
        self.useCase = DefaultServiceTokenUseCaseProvider().makeDefaultServiceTokenUseCase()
    }
    
    func isTokenExpired() -> Bool {
        guard let serviceToken = useCase.loadToken() else {
            return true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let refreshExpiredAt = dateFormatter.date(from: serviceToken.refreshExpiredAt) else {
            return true
        }
        
        if refreshExpiredAt <= Date() {
            return true
        }
        
        return false
    }
}
