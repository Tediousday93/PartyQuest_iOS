//
//  DefaultServiceTokenUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

import Foundation

final class DefaultServiceTokenUseCase: ServiceTokenUseCase {
    private let service: KeychainService
    
    init(service: KeychainService) {
        self.service = service
    }
    
    func saveToken(serviceToken: ServiceToken) throws {
        let data = try JSONEncoder().encode(serviceToken)
        service.saveValue(data, forKey: "SERVICE_TOKEN")
    }
    
    func loadToken() -> ServiceToken? {
        guard let data = service.loadValue(forKey: "SERVICE_TOKEN") else { return nil }
        let serviceToken = try? JSONDecoder().decode(ServiceToken.self, from: data)
        
        return serviceToken
    }
    
    func deleteToken() {
        service.deleteValue(forKey: "SERVICE_TOKEN")
    }
}
