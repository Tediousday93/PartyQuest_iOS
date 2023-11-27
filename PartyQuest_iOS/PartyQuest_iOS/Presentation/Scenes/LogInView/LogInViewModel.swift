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
    private let serviceTokenUseCase: ServiceTokenUseCase
    
    private let userLogedIn: PublishSubject<LogInPlatform> = .init()
    
    init(coordinator: LogInCoordinator,
         authenticationUseCase: AuthenticationUseCase,
         kakaoSocialUserDataUseCase: SocialUserDataUseCase,
         serviceTokenUseCase: ServiceTokenUseCase) {
        self.coordinator = coordinator
        self.authenticationUseCase = authenticationUseCase
        self.kakaoSocialUserDataUseCase = kakaoSocialUserDataUseCase
        self.serviceTokenUseCase = serviceTokenUseCase
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
        let errorRelay: PublishRelay<Error>
        let userInputsValidation: Driver<(Bool,Bool)>
        let isEnableLogInButton: Driver<Bool>
        let logInSucceeded: Observable<Void>
        let jwtSaved: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorRelay: PublishRelay<Error> = .init()
        
        let userInputs = Observable.combineLatest(input.email,
                                                  input.password)
        
        let userInputsValidation = userInputs
            .map { email, password in
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
        
        let isEnableLogInButton = userInputsValidation
            .map { isEmailValid, isPasswordValid in
                return isEmailValid && isPasswordValid
            }
        
        let kakaoLogIn = input.kakaoLogInButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.kakaoSocialUserDataUseCase.logIn()
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.kakaoSocialUserDataUseCase.socialUserData()
            }
        
        let jwtSaved = kakaoLogIn
            .withUnretained(self)
            .flatMap { owner, requestModel in
                owner.authenticationUseCase.socialLogIn(requestModel: requestModel)
            }
            .compactMap { $0.tokenData.first }
            .withUnretained(self)
            .map { owner, serviceToken in
                try owner.serviceTokenUseCase.saveToken(serviceToken: serviceToken)
            }
            .catch { error in
                debugPrint(error.localizedDescription)
                return Observable.just(())
            }
        
        let logInSucceeded = input.logInButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password in
                return (email: email, password: password)
            }
            .withUnretained(self)
            .flatMap { owner, userInputs in
                owner.authenticationUseCase.logIn(email: userInputs.email,
                                                  password: userInputs.password)
            }
            .map { _ in }
        
        return Output(
            errorRelay: errorRelay,
            userInputsValidation: userInputsValidation,
            isEnableLogInButton: isEnableLogInButton,
            logInSucceeded: logInSucceeded,
            jwtSaved: jwtSaved
        )
    }
}
