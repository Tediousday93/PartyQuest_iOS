//
//  HomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/13.
//

import UIKit

protocol HomeCoordinatorType: Coordinator {
    
}

final class HomeCoordinator: HomeCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
