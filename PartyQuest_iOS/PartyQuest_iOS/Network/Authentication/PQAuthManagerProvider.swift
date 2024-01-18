//
//  DefaultAuthenticationUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

import Moya

final class PQAuthManagerProvider: AuthenticationManagerProvider {
    private let service: AuthenticationService
    
    init() {
        self.service = PQAuthenticationService(provider: MoyaProvider<AuthenticationAPI>())
    }
    
    func makePQAuthManager() -> AuthenticationManagable {
        return PQAuthManager(service: service)
    }
}
