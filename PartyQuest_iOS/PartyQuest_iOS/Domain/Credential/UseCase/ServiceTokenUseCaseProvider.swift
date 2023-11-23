//
//  ServiceTokenUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

protocol ServiceTokenUseCaseProvider {
    func makeDefaultServiceTokenUseCase() -> ServiceTokenUseCase
}
