//
//  AppCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let useCaseProvider: AuthentificationUseCaseProvider
    
    override init(navigationController: UINavigationController) {
        self.useCaseProvider = DefaultAuthentificationUseCaseProvider()
        super.init(navigationController: navigationController)
    }
    override func start() {
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController,
            useCaseProvider: useCaseProvider
        )
        
        start(coordinator: coordinator)
    }
}
