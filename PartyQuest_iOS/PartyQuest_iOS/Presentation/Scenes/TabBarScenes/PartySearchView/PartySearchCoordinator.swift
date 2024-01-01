//
//  PartySearchCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/01.
//

import UIKit

protocol PartySearchCoordinatorType: Coordinator {
    
}

final class PartySearchCoordinator: PartySearchCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
}
