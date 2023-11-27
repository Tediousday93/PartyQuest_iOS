//
//  WelcomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

final class WelcomeCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    init(navigationController: UINavigationController,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let welcomeViewModel = WelcomeViewModel(
            coordinator: self,
            serviceTokenUseCase: serviceTokenUseCaseProvider.makeDefaultServiceTokenUseCase()
        )
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    override func didFinish(coordinator: Coordinator) {
        super.didFinish(coordinator: coordinator)
        navigationController.popViewController(animated: true)
    }
    
    func coordinateToLogin() {
        let loginCoordinator = LogInCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            socialUserDataUseCaseProvider: socialUserDataUseCaseProvider,
            serviceTokenUseCaseProvider: serviceTokenUseCaseProvider
        )

        self.start(coordinator: loginCoordinator)
    }
    
    func coordinateToSignUp() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            useCaseProvider: authenticationUseCaseProvider
        )
        
        self.start(coordinator: signUpCoordinator)
    }
}
