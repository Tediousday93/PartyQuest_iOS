//
//  PartyInfoCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/23.
//

import UIKit

protocol PartyInfoCoordinatorType: Coordinator {
    
}

final class PartyInfoCoordinator: PartyInfoCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
}
