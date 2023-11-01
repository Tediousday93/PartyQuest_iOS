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
    
    init(coordinator: WelcomeCoordinator) {
        self.coordinator = coordinator
    }
}

extension WelcomeViewModel: ViewModelType {
    struct Input {
        let loginButtonTapped: Observable<Void>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let socialLoginPushed: Driver<Void>
        let signUpPushed: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let socialLoginPushed = input.loginButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.coordinateToSocialLogin()
            }
            .asDriver(onErrorJustReturn: ())
        
        let signUpPushed = input.signUpButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.coordinateToSignUp()
            }
            .asDriver(onErrorJustReturn: ())
        
        return Output(socialLoginPushed: socialLoginPushed,
                      signUpPushed: signUpPushed)
    }
}
