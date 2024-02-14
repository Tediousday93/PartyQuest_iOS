//
//  CreatePartyCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit
import RxCocoa

protocol CreatePartyCoordinatorType: Coordinator {
    func toPartyList()
    func presentModifyingView(with itemsRelay: BehaviorRelay<[ModifyingItem]>, itemIndex: Int)
}

final class CreatePartyCoordinator: CreatePartyCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CreatePartyViewModel(coordinator: self)
        let viewController = CreatePartyViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .automatic
        let nc = UINavigationController(rootViewController: viewController)
        
        navigationController?.present(nc, animated: true)
    }
    
    func toPartyList() {
        finish()
        navigationController?.dismiss(animated: true)
    }
    
    func presentModifyingView(with itemsRelay: BehaviorRelay<[ModifyingItem]>, itemIndex: Int) {
        
    }
}
