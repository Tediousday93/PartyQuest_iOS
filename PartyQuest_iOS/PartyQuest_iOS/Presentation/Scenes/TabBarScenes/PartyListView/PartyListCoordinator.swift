//
//  PartyListCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import UIKit

protocol PartyListCoordinatorType: Coordinator {
    func toCreateParty()
}

final class PartyListCoordinator: PartyListCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let partyListViewModel = PartyListViewModel(coordinator: self)
        let partyListViewController = PartyListViewController(viewModel: partyListViewModel)
        
        navigationController?.pushViewController(partyListViewController, animated: true)
    }
    
    func toCreateParty() {
        let coordinator = CreatePartyCoordinator(navigationController: navigationController)
        start(child: coordinator)
    }
}
