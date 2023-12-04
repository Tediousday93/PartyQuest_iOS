//
//  PQApplication.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import UIKit

final class PQApplication {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    init() {
        self.authenticationUseCaseProvider = DefaultAuthenticationUseCaseProvider()
        self.socialUserDataUseCaseProvider = DefaultSocialUserDataUseCaseProvider()
        self.serviceTokenUseCaseProvider = DefaultServiceTokenUseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow?) {
        if TokenUtils.shared.isTokenExpired() {
            let navigationController = UINavigationController()
            let enteranceCoordinator = EnteranceCoordinator(
                navigationController: navigationController,
                authenticationUseCaseProvider: authenticationUseCaseProvider,
                socialUserDataUseCaseProvider: socialUserDataUseCaseProvider,
                serviceTokenUseCaseProvider: serviceTokenUseCaseProvider
            )
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            enteranceCoordinator.start()
        } else {
            let tabBar = PQTabBarController()
        }
    }
}
