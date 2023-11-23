//
//  AppCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    override init(navigationController: UINavigationController) {
        self.authenticationUseCaseProvider = DefaultAuthenticationUseCaseProvider()
        self.socialUserDataUseCaseProvider = DefaultSocialUserDataUseCaseProvider()
        self.serviceTokenUseCaseProvider = DefaultServiceTokenUseCaseProvider()
        
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            socialUserDataUseCaseProvider: socialUserDataUseCaseProvider,
            serviceTokenUseCaseProvider: serviceTokenUseCaseProvider
        )
        
        start(coordinator: coordinator)
    }
}
