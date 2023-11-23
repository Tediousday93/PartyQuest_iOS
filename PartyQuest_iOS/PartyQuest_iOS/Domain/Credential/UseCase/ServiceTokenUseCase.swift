//
//  ServiceTokenUseCase.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

import Foundation

protocol ServiceTokenUseCase {
    func saveToken(serviceToken: ServiceToken) throws
    func loadToken() -> ServiceToken?
    func deleteToken()
}
