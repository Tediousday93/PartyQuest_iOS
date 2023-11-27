//
//  WelcomeViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/01.
//

import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModel {
    private let coordinator: WelcomeCoordinator
    private let serviceTokenUseCase: ServiceTokenUseCase
    
    init(coordinator: WelcomeCoordinator,
         serviceTokenUseCase: ServiceTokenUseCase) {
        self.coordinator = coordinator
        self.serviceTokenUseCase = serviceTokenUseCase
    }
}

extension WelcomeViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let loginButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let loginPushed: Driver<Void>
        let signUpPushed: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let loginPushed = input.loginButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.coordinateToLogin()
            }
            .asDriver(onErrorJustReturn: ())
        
        let signUpPushed = input.signUpButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.coordinateToSignUp()
            }
            .asDriver(onErrorJustReturn: ())
        
        return Output(loginPushed: loginPushed,
                      signUpPushed: signUpPushed)
    }
}
