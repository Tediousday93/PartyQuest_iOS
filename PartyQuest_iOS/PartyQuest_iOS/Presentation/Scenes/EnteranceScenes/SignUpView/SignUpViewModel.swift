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
    private let coordinator: SignUpCoordinator
    private let useCase: AuthenticationUseCase
    
    init(coordinator: SignUpCoordinator,
         useCase: AuthenticationUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
}

extension SignUpViewModel: ViewModelType {
    typealias InputState = TitledTextfield.InputState
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let birthDate: Observable<String>
        let nickname: Observable<String>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let errorRelay: PublishRelay<Error>
        let inputStates: Driver<(InputState, InputState, InputState, InputState)>
        let isEnableSignUpButton: Driver<Bool>
        let signUpSucceeded: Observable<Void>
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
        
        let userInputsValidation = userInputs
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
            .share()
            .asDriver(onErrorJustReturn: (true, true, true, true))
            
        
        let inputStates = userInputsValidation
            .map { validation in
                var states: (InputState, InputState, InputState, InputState)
                validation.0 ? (states.0 = .correct) : (states.0 = .incorrect)
                validation.1 ? (states.1 = .correct) : (states.1 = .incorrect)
                validation.2 ? (states.2 = .correct) : (states.2 = .incorrect)
                validation.3 ? (states.3 = .correct) : (states.3 = .incorrect)
                
                return states
            }
        
        let isEnableSignUpButton = userInputsValidation
            .map { $0 && $1 && $2 && $3 }
        
        let signUpSuccessed = input.signUpButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password, birthDate, nickname in
                return (email: email,
                        password: password,
                        birthDate: birthDate,
                        nickname: nickname)
            }
            .withUnretained(self)
            .flatMap { owner, userInputs in
                owner.useCase.signUp(email: userInputs.email,
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
            .compactMap { owner, _ in
                owner.coordinator.parentCoordinator?.didFinish(coordinator: owner.coordinator)
            }
        
        return Output(
            errorRelay: errorRelay,
            inputStates: inputStates,
            isEnableSignUpButton: isEnableSignUpButton,
            signUpSucceeded: signUpSuccessed
        )
    }
}
