//
//  SignUpCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation
import UIKit

final class SignUpCoordinator: BaseCoordinator {
    private let useCaseProvider: AuthentificationUseCaseProvider
    
    init(navigationController: UINavigationController, useCaseProvider: AuthentificationUseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let signUpViewModel = SignUpViewModel(
            coordinator: self,
            useCase: useCaseProvider.makeDefaultAuthentificationUseCase()
        )
        let signUpViewController = SignUpViewController(signUpViewModel: signUpViewModel)
        
        navigationController.pushViewController(signUpViewController, animated: true)
    }
}
