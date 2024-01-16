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
    
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let userDataUseCaseProvider: UserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    private let isLoggedIn: PublishSubject<Bool>
    
    init(navigationController: UINavigationController?,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         userDataUseCaseProvider: UserDataUseCaseProvider,
         serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider,
         isLoggedIn: PublishSubject<Bool>) {
        self.navigationController = navigationController
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.userDataUseCaseProvider = userDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        self.isLoggedIn = isLoggedIn
    }
    
    func start() {
        let welcomeViewModel = WelcomeViewModel(
            coordinator: self,
            serviceTokenUseCase: serviceTokenUseCaseProvider.makeDefaultServiceTokenUseCase()
        )
        let welcomeViewController = WelcomeViewController(welcomeViewModel: welcomeViewModel)
        
        navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
    func toLogIn() {
        let loginCoordinator = LogInCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            userDataUseCaseProvider: userDataUseCaseProvider,
            serviceTokenUseCaseProvider: serviceTokenUseCaseProvider,
            isLoggedIn: isLoggedIn
        )

        start(child: loginCoordinator)
    }
    
    func toSignUp() {
        let signUpCoordinator = SignUpCoordinator(
            navigationController: navigationController,
            useCaseProvider: authenticationUseCaseProvider
        )
        
        start(child: signUpCoordinator)
    }
}
