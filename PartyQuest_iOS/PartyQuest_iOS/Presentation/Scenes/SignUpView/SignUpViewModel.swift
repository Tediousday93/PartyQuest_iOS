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
    let errorRelay: PublishRelay<Error> = .init()
    
    init(coordinator: SignUpCoordinator,
         useCase: AuthenticationUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
}

extension SignUpViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let birthDate: Observable<String>
        let nickname: Observable<String>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let userInputsValidation: Driver<(Bool, Bool, Bool, Bool)>
        let isEnableSignUpButton: Driver<Bool>
        let signUpSucceeded: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
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
            .asDriver(onErrorJustReturn: (true, true, true, true))
        
        let isEnableSignUpButton = userInputsValidation
            .map { isEmailValid, isPasswordValid, isNicknameValid, isValidBirthDate in
                return isEmailValid && isPasswordValid && isNicknameValid && isValidBirthDate
            }
        
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
                .do(onNext: { [weak self] event in
                    if let error = event.error {
                        self?.errorRelay.accept(error)
                    }
                })
                .filter { $0.error == nil }
            }
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.coordinator.parentCoordinator?.didFinish(coordinator: owner.coordinator)
            }
        
        return Output(userInputsValidation: userInputsValidation,
                      isEnableSignUpButton: isEnableSignUpButton,
                      signUpSucceeded: signUpSuccessed)
    }
}
