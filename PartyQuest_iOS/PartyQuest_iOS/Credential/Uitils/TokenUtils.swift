//
//  TokenUtils.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import Foundation

final class TokenUtils {
    static let shared = TokenUtils()
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    private let keychain: KeychainService
    
    private init() {
        self.keychain = PasswordKeychain(serviceName: "PartyQuest")
    }
    
    func isTokenExpired() -> Bool {
        guard let serviceToken = loadToken(),
              let refreshExpiredAt = dateFormatter.date(from: serviceToken.refreshExpiredAt)
        else { return true }
        
        return refreshExpiredAt <= Date()
    }
    
    func saveToken(serviceToken: ServiceToken) {
        if let data = serviceToken.toData() {
            keychain.saveValue(data, forKey: "SERVICE_TOKEN")
        }
    }
    
    func loadToken() -> ServiceToken? {
        guard let data = keychain.loadValue(forKey: "SERVICE_TOKEN") else { return nil }
        
        return data.decodeJSON(to: ServiceToken.self)
    }
    
    func deleteToken() {
        keychain.deleteValue(forKey: "SERVICE_TOKEN")
    }
}
