//
//  SettingCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/26.
//

final class SettingCoordinator: BaseCoordinator {
 
    override func start() {
        let viewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}
