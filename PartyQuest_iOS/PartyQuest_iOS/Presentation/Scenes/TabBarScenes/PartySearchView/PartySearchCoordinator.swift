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
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PartySearchViewModel(coordinator: self)
        let viewController = PartySearchViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
