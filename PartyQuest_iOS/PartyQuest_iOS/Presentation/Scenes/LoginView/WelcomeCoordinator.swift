//
//  WelcomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

class WelcomeCoordinator: BaseCoordinator {
    
    override func start() {
        let welcomeViewController = WelcomeViewController()
        
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
    
    func coordinateToSocialLogin() {
        let socialLoginCoordinator = SocialLogInCoordinator(navigationController: navigationController)
        
        self.start(coordinator: socialLoginCoordinator)
    }
}
