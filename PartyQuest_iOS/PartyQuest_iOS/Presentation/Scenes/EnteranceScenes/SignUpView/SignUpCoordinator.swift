//
//  SignUpCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit

protocol SignUpCoordinatorType: Coordinator {
    func toWelcome()
}

final class SignUpCoordinator: SignUpCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let useCaseProvider: AuthenticationUseCaseProvider
    
    init(navigationController: UINavigationController?,
         useCaseProvider: AuthenticationUseCaseProvider) {
        self.navigationController = navigationController
        self.useCaseProvider = useCaseProvider
    }
    
    func start() {
        let signUpViewModel = SignUpViewModel(
            coordinator: self,
            useCase: useCaseProvider.makeDefaultAuthenticationUseCase()
        )
        let signUpViewController = SignUpViewController(signUpViewModel: signUpViewModel)
        
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func toWelcome() {
        finish()
        navigationController?.popViewController(animated: true)
    }
}
