//
//  AuthentificationUseCaseProvider.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/03.
//

import Foundation

protocol AuthentificationUseCaseProvider {
    func makeDefaultAuthentificationUseCase() -> AuthentificationUsecase
}
