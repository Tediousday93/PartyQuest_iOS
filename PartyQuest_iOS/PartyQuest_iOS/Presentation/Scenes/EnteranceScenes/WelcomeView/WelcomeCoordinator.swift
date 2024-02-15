//
//  WelcomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit
import RxSwift

protocol WelcomeCoordinatorType: Coordinator {
    func toLogIn()
    func toSignUp()
}

final class WelcomeCoordinator: WelcomeCoordinatorType {
    var navigationController: UINavigationController?
        
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let authenticationManagerProvider: AuthenticationManagerProvider
    private let socialUserUseCaseProvider: SocialUserUseCaseProvider
    private let isLoggedIn: PublishSubject<Bool>
    
    init(navigationController: UINavigationController?,
         authenticationManagerProvider: AuthenticationManagerProvider,
         socialUserUseCaseProvider: SocialUserUseCaseProvider,
         isLoggedIn: PublishSubject<Bool>) {
        self.navigationController = navigationController
        self.authenticationManagerProvider = authenticationManagerProvider
        self.socialUserUseCaseProvider = socialUserUseCaseProvider
        self.isLoggedIn = isLoggedIn
    }
    
    func start() {
        let welcomeViewModel = WelcomeViewModel(coordinator: self)
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
    func toLogIn() {
        let loginCoordinator = LogInCoordinator(
            navigationController: navigationController,
            authenticationManagerProvider: authenticationManagerProvider,
            socialUserUseCaseProvider: socialUserUseCaseProvider,
            isLoggedIn: isLoggedIn
        )

        start(child: loginCoordinator)
    }
    
    func toSignUp() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            authenticationManagerProvider: authenticationManagerProvider
        )
        
        start(child: signUpCoordinator)
    }
}
