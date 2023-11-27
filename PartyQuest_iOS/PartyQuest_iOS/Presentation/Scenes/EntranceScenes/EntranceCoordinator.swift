//
//  AppCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

final class EntranceCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    init(navigationController: UINavigationController,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider:ServiceTokenUseCaseProvider) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        
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
