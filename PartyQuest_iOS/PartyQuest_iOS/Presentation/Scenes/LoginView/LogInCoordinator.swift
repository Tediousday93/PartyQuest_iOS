//
//  LogInCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation
import UIKit

final class LogInCoordinator: BaseCoordinator {
    private let useCaseProvider: AuthenticationUseCaseProvider
    
    init(navigationController: UINavigationController, useCaseProvider: AuthenticationUseCaseProvider) {
        self.useCaseProvider = useCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let socialLoginViewController = LoginViewController()
        
        navigationController.pushViewController(socialLoginViewController, animated: true)
    }
}
