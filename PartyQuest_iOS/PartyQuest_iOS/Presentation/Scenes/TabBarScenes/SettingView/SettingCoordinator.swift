//
//  SettingCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/26.
//

import UIKit

protocol SettingCoordinatorType: Coordinator {
    
}

final class SettingCoordinator: SettingCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}
