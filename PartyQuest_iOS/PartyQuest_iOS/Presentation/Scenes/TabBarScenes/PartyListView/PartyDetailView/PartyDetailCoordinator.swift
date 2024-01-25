//
//  PartyDetailCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/03.
//

import UIKit

protocol PartyDetailCoordinatorType: Coordinator { }

final class PartyDetailCoordinator: PartyDetailCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let partyDetailViewModel = PartyDetailViewModel(coordinator: self)
        let partyDetailViewController = PartyDetailViewController(viewModel: partyDetailViewModel)
        
        navigationController?.pushViewController(partyDetailViewController, animated: true)
    }
}
