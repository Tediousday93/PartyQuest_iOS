//
//  CreatePartyCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit

final class CreatePartyCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = CreatePartyViewModel()
        let viewController = CreatePartyViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .automatic
        let nc = UINavigationController(rootViewController: viewController)
        
        navigationController?.present(nc, animated: true)
    }
}
