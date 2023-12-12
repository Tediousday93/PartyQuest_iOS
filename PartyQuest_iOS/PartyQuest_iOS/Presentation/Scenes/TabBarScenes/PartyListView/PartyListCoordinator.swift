//
//  PartyListCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import Foundation

final class PartyListCoordinator: BaseCoordinator {
    override func start() {
        let partyListViewModel = PartyListViewModel()
        let partyListViewController = PartyListViewController()
        
        navigationController?.pushViewController(partyListViewController, animated: true)
    }
}
