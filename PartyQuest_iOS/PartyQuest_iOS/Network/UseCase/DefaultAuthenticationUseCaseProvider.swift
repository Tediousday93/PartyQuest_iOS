//
//  DefaultAuthenticationUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

final class DefaultAuthenticationUseCaseProvider: AuthenticationUseCaseProvider {
    private let serviceProvider: NetworkServiceProvider
    
    init() {
        self.serviceProvider = NetworkServiceProvider()
    }
    
    func makeDefaultAuthenticationUseCase() -> AuthenticationUseCase {
        let service = serviceProvider.makeDefaultAuthenticationService()
        
        return DefaultAuthenticationUseCase(service: service)
    }
}
