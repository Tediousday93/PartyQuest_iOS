//
//  LogInViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift
import RxCocoa

final class LogInViewModel {
    private let coordinator: LogInCoordinator
    private let authenticationUseCase: AuthenticationUseCase
    private let kakaoSocialUserDataUseCase: SocialUserDataUseCase
    
    private let userLogedIn: PublishSubject<Void> = .init()
    let errorRelay: PublishRelay<Error> = .init()
    
    init(coordinator: LogInCoordinator,
         authenticationUseCase: AuthenticationUseCase,
         kakaoSocialUserDataUseCase: SocialUserDataUseCase) {
        self.coordinator = coordinator
        self.authenticationUseCase = authenticationUseCase
        self.kakaoSocialUserDataUseCase = kakaoSocialUserDataUseCase
    }
}

extension LogInViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let logInButtonTapped: Observable<Void>
        let kakaoLogInButtonTapped: Observable<Void>
    }
    
    struct Output {
        let userInputsValidation: Driver<(Bool,Bool)>
        let isEnableLogInButton: Driver<Bool>
        let kakaoLogIn: Observable<Void>
        let logInSucceeded: Observable<Void>
        let jwtSaved: Observable<SocialUserData>
    }
    
    func transform(_ input: Input) -> Output {
        let userInputs = Observable.combineLatest(input.email,
                                                  input.password)
        let userInputsValidation = userInputs.map { email, password in
            var validation = (true, true)
            if email.isEmpty == false {
                validation.0 = email.isValidEmail()
            }
            if password.isEmpty == false {
                validation.1 = password.isValidPassword()
            }
            
            return validation
        }
        .asDriver(onErrorJustReturn: (true, true))
        
        let isEnableLogInButton = userInputsValidation.map { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }
        
        let kakaoLogIn = input.kakaoLogInButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.kakaoSocialUserDataUseCase.logIn()
            }
            .withUnretained(self)
            .map { owner, result in
                switch result {
                case .success():
                    owner.userLogedIn.onNext(())
                case .failure(let error):
                    owner.errorRelay.accept(error)
                }
            }
        
        let jwtSaved = userLogedIn
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.kakaoSocialUserDataUseCase.socialUserData()
            }
        
        let logInSucceeded = input.logInButtonTapped.withLatestFrom(userInputs)
            .map { email, password in
                return (email: email, password: password)
            }
            .withUnretained(self)
            .flatMap { owner, userInputs in
                owner.authenticationUseCase.logIn(email: userInputs.email,
                                                  password: userInputs.password)
            }
            .map { _ in }
        
        return Output(userInputsValidation: userInputsValidation,
                      isEnableLogInButton: isEnableLogInButton,
                      kakaoLogIn: kakaoLogIn,
                      logInSucceeded: logInSucceeded,
                      jwtSaved: jwtSaved)
    }
}
