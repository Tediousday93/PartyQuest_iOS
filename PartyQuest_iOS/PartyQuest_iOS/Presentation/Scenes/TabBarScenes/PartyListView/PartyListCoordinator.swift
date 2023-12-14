//
//  PartyListCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import UIKit

final class PartyListCoordinator: BaseCoordinator {
    override func start() {
        let partyListViewModel = PartyListViewModel()
        let partyListViewController = PartyListViewController(viewModel: partyListViewModel)
        
        navigationController?.pushViewController(partyListViewController, animated: true)
    }
}
