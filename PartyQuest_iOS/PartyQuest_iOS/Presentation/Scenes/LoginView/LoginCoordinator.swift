//
//  LoginCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

class LogInCoordinator: BaseCoordinator {
    
    override func start() {
        let welcomeViewController = WelcomeViewController()
        
        navigationController.viewControllers = [welcomeViewController]
    }
}
