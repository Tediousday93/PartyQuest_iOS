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
        let birthDate: Observable<String>
        let nickname: Observable<String>
        let signUpButtonTapped: Observable<Void>
        let willDeallocated: Observable<Void>
    }
    
    struct Output {
        let errorRelay: PublishRelay<Error>
        let inputValidations: Driver<(Bool, Bool, Bool, Bool)>
        let isEnableSignUpButton: Driver<Bool>
        let signUpSuccessed: Observable<Void>
        let coordinatorFinished: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorRelay: PublishRelay<Error> = .init()
        
        let userInputs = Observable.combineLatest(
            input.email,
            input.password,
            input.nickname,
            input.birthDate
        )
            .share()
        
        let inputValidations = userInputs
            .map { email, password, nickname, birthDate in
                var validation = (true, true, true, true)
                if email.isEmpty == false {
                    validation.0 = email.isValidEmail()
                }
                if password.isEmpty == false {
                    validation.1 = password.isValidPassword()
                }
                if nickname.isEmpty == false {
                    validation.2 = nickname.isValidNickname()
                }
                if birthDate.isEmpty == false {
                    validation.3 = birthDate.isValidBirthDate()
                }
                return validation
            }
            .asDriver(onErrorJustReturn: (true, true, true, true))
        
        let isEnableSignUpButton = userInputs
            .map { email, password, nickname, birthDate in
                var validation = (false, false, false, false)
                if email.isEmpty == false {
                    validation.0 = email.isValidEmail()
                }
                if password.isEmpty == false {
                    validation.1 = password.isValidPassword()
                }
                if nickname.isEmpty == false {
                    validation.2 = nickname.isValidNickname()
                }
                if birthDate.isEmpty == false {
                    validation.3 = birthDate.isValidBirthDate()
                }
                return validation
            }
            .map { $0 && $1 && $2 && $3 }
            .asDriver(onErrorJustReturn: false)
        
        let signUpSuccessed = input.signUpButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password, birthDate, nickname in
                return UserData(email: email,
                                secrets: password,
                                nickName: nickname)
            }
            .withUnretained(self)
            .flatMap { owner, userData in
                owner.authenticationManager.signUp(userData: userData)
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
