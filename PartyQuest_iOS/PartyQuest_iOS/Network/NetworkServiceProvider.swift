//
//  NetworkServiceProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

import Foundation
import Moya

struct NetworkServiceProvider {
    func makeDefaultAuthentificationService() -> AuthentificationService {
        return DefaultAuthentificationService(provider: MoyaProvider<AuthentificationAPI>())
    }
}
