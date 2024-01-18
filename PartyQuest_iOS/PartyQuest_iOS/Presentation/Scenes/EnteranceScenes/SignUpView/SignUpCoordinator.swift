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
    
    private let authenticationManagerProvider: AuthenticationManagerProvider
    
    init(navigationController: UINavigationController?,
         authenticationManagerProvider: AuthenticationManagerProvider) {
        self.navigationController = navigationController
        self.authenticationManagerProvider = authenticationManagerProvider
    }
    
    func start() {
        let signUpViewModel = SignUpViewModel(
            coordinator: self,
            authenticationManager: authenticationManagerProvider.makePQAuthManager()
        )
        let signUpViewController = SignUpViewController(signUpViewModel: signUpViewModel)
        
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func toWelcome() {
        finish()
        navigationController?.popViewController(animated: true)
    }
}
