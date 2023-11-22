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
    
    override init(navigationController: UINavigationController) {
        self.authenticationUseCaseProvider = DefaultAuthenticationUseCaseProvider()
        self.socialUserDataUseCaseProvider = DefaultSocialUserDataUseCaseProvider()
        
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            socialUserDataUseCaseProvider: socialUserDataUseCaseProvider
        )
        
        start(coordinator: coordinator)
    }
}
