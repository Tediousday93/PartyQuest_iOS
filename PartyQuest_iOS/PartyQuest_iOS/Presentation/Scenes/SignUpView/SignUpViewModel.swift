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
    private let useCase: AuthentificationUseCase
    
    init(coordinator: SignUpCoordinator,
         useCase: AuthentificationUseCase) {
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
        let userInputsValidation: Driver<(Bool, Bool, Bool)>
        let isEnableSignUpButton: Driver<Bool>
        let signUpSuccessed: Observable<Void>
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
            .map { email, password, nickname, _ in
                var validation = (true, true, true)
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
            .asDriver(onErrorJustReturn: (true, true, true))
        
        let isEnableSignUpButton = userInputsValidation
            .map { isEmailValid, isPasswordValid, isNicknameValid in
                return isEmailValid && isPasswordValid && isNicknameValid
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
                                     nickname: userInputs.nickname,
                                     birth: userInputs.birthDate)
            }
//            .catchAndReturn(())
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.coordinator.parentCoordinator?.didFinish(coordinator: owner.coordinator)
            }
        
        return Output(userInputsValidation: userInputsValidation,
                      isEnableSignUpButton: isEnableSignUpButton,
                      signUpSuccessed: signUpSuccessed)
    }
}
