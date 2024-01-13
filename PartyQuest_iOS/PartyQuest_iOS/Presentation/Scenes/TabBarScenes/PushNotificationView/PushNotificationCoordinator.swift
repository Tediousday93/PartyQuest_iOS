//
//  PushNotificationCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/03.
//

import UIKit

protocol PushNotificationCoordinatorType: Coordinator {
    
}

final class PushNotificationCoordinator: PushNotificationCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PushNotificationViewModel(coordinator: self)
        let viewController = PushNotificationViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
