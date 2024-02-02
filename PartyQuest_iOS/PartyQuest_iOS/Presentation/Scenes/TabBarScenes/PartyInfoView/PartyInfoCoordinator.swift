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
    
    private var partyItem: PartyItem
    
    init(navigationController: UINavigationController?, partyItem: PartyItem) {
        self.navigationController = navigationController
        self.partyItem = partyItem
    }
    
    func start() {
        let viewModel = PartyInfoViewModel(
            partyItem: partyItem,
            coordinator: self
        )
        let viewController = PartyInfoViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
