//
//  SettingViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/26.
//

import RxSwift

final class SettingViewModel {
    private let coordinator: SettingCoordinator
    
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
}

extension SettingViewModel: ViewModelType {
    struct Input {
    }
    
    struct Output {
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
