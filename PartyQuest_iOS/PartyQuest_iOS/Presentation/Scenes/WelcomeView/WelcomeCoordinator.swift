//
//  WelcomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

final class WelcomeCoordinator: BaseCoordinator {
    private let useCaseProvider: AuthentificationUseCaseProvider
    
    init(navigationController: UINavigationController, useCaseProvider: AuthentificationUseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let welcomeViewModel = WelcomeViewModel(coordinator: self)
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
            useCaseProvider: useCaseProvider
        )
        
        self.start(coordinator: loginCoordinator)
    }
    
    func coordinateToSignUp() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            useCaseProvider: useCaseProvider
        )
        
        self.start(coordinator: signUpCoordinator)
    }
}
