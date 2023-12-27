//
//  PartyListCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import UIKit

final class PartyListCoordinator: BaseCoordinator {
    override func start() {
        let partyListViewModel = PartyListViewModel(coordinator: self)
        let partyListViewController = PartyListViewController(viewModel: partyListViewModel)
        
        navigationController?.pushViewController(partyListViewController, animated: true)
    }
    
    func coordinateToCreateParty() {
        let coordinator = CreatePartyCoordinator(navigationController: navigationController)
        start(coordinator: coordinator)
    }
}
