//
//  HomeCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/13.
//

final class HomeCoordinator: BaseCoordinator {
 
    override func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
