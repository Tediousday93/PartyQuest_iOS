//
//  SignUpViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    private let coordinator: SignUpCoordinatorType
    private let authenticationManager: AuthenticationManagable
    
    init(coordinator: SignUpCoordinatorType,
         authenticationManager: AuthenticationManagable) {
        self.coordinator = coordinator
        self.authenticationManager = authenticationManager
    }
}

extension SignUpViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let nickname: Observable<String>
        let signUpButtonTapped: Observable<Void>
        let willDeallocated: Observable<Void>
    }
    
    struct Output {
        let errorRelay: PublishRelay<Error>
        let inputValidations: Driver<(email: Bool, password: Bool, nickname: Bool)>
        let isEnableSignUpButton: Driver<Bool>
        let signUpSuccessed: Observable<Void>
        let coordinatorFinished: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorRelay: PublishRelay<Error> = .init()
        
        let userInputs = Observable.combineLatest(
            input.email,
            input.password,
            input.nickname
        )
            .map { (email: $0, password: $1, nickname: $2) }
            .share()
        
        let inputValidations = userInputs
            .map { email, password, nickname in
                var validation = (email: true, password: true, nickname: true)
                
                if email.isEmpty == false {
                    validation.email = email.isValidEmail()
                }
                if password.isEmpty == false {
                    validation.password = password.isValidPassword()
                }
                if nickname.isEmpty == false {
                    validation.nickname = nickname.isValidNickname()
                }
                
                return validation
            }
            .asDriver(onErrorJustReturn: (email: true, password: true, nickname: true))
        
        let isEnableSignUpButton = userInputs
            .map { email, password, nickname in
                var validation = (false, false, false)
                
                if email.isEmpty == false {
                    validation.0 = email.isValidEmail()
                }
                if password.isEmpty == false {
                    validation.1 = password.isValidPassword()
                }
                if nickname.isEmpty == false {
                    validation.2 = nickname.isValidNickname()
                }
                
                return validation
            }
            .map { $0 && $1 && $2 }
            .asDriver(onErrorJustReturn: false)
        
        let signUpSuccessed = input.signUpButtonTapped
            .withLatestFrom(userInputs)
            .withUnretained(self)
            .flatMap { owner, userInputs in
                owner.authenticationManager.signUp(email: userInputs.email,
                                                   password: userInputs.password,
                                                   nickname: userInputs.nickname)
                    .asObservable()
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.toWelcome()
            }
        
        let coordinatorFinished = input.willDeallocated
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.finish()
            }
        
        return Output(
            errorRelay: errorRelay,
            inputValidations: inputValidations,
            isEnableSignUpButton: isEnableSignUpButton,
            signUpSuccessed: signUpSuccessed,
            coordinatorFinished: coordinatorFinished
        )
    }
}
