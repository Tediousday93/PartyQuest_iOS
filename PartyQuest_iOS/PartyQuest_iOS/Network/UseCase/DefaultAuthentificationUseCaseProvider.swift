//
//  DefaultAuthentificationUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

final class DefaultAuthentificationUseCaseProvider: AuthentificationUseCaseProvider {
    private let serviceProvider: NetworkServiceProvider
    
    init() {
        self.serviceProvider = NetworkServiceProvider()
    }
    
    func makeDefaultAuthentificationUseCase() -> AuthentificationUseCase {
        let service = serviceProvider.makeDefaultAuthentificationService()
        
        return DefaultAuthentificationUseCase(service: service)
    }
}
