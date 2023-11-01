//
//  SignUpCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation

class SignUpCoordinator: BaseCoordinator {
    
    override func start() {
        let signUpViewModel = SignUpViewModel(coordinator: self)
        let signUpViewController = SignUpViewController(signUpViewModel: signUpViewModel)
        
        navigationController.pushViewController(signUpViewController, animated: true)
    }
}