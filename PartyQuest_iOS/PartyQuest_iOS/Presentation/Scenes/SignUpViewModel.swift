//
//  SignUpViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation

final class SignUpViewModel {
    private let coordinator: SignUpCoordinator
    
    init(coordinator: SignUpCoordinator) {
        self.coordinator = coordinator
    }
}

extension SignUpViewModel: ViewModelType {
    struct Input {

    }
    
    struct Output {

    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
