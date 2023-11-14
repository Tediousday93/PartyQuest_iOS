//
//  AuthenticationUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

protocol AuthenticationUseCaseProvider {
    func makeDefaultAuthenticationUseCase() -> AuthenticationUseCase
}
