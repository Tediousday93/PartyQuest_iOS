//
//  AppCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

class AppCoordinator: BaseCoordinator {
    
    override func start() {
        let coordinator = LogInCoordinator(navigationController: navigationController)
        
        start(coordinator: coordinator)
    }
}
