//
//  SocialLoginCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation

class SocialLogInCoordinator: BaseCoordinator {
    
    override func start() {
        let socialLoginViewController = SocialLoginViewController()
        
        navigationController.pushViewController(socialLoginViewController, animated: true)
    }
}
