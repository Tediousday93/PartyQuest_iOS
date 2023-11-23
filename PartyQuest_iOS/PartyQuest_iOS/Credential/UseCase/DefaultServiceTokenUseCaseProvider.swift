//
//  DefaultServiceTokenUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

final class DefaultServiceTokenUseCaseProvider: ServiceTokenUseCaseProvider {
    private let serviceProvider: KeychainServiceProvider
    
    init() {
        self.serviceProvider = KeychainServiceProvider()
    }
    
    func makeDefaultServiceTokenUseCase() -> ServiceTokenUseCase {
        return DefaultServiceTokenUseCase(service: serviceProvider.makePasswordKeychain())
    }
}
