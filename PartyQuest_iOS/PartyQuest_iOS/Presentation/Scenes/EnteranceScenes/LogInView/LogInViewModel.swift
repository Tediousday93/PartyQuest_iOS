//
//  LogInViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift
import RxCocoa
import GoogleSignIn

final class LogInViewModel {
    private let coordinator: LogInCoordinator
    private let authenticationUseCase: AuthenticationUseCase
    private let kakaoSocialUserDataUseCase: SocialUserDataUseCase
    private let googleSocialUserDataUseCase: SocialUserDataUseCase
    private let naverSocialUserDataUseCase: SocialUserDataUseCase
    private let serviceTokenUseCase: ServiceTokenUseCase
    
    private let isLoggedIn: PublishSubject<Bool>
    
    init(coordinator: LogInCoordinator,
         authenticationUseCase: AuthenticationUseCase,
         kakaoSocialUserDataUseCase: SocialUserDataUseCase,
         googleSocialUserDataUseCase: SocialUserDataUseCase,
         naverSocialUserDataUseCase: SocialUserDataUseCase,
         serviceTokenUseCase: ServiceTokenUseCase,
         isLoggedIn: PublishSubject<Bool>) {
        self.coordinator = coordinator
        self.authenticationUseCase = authenticationUseCase
        self.kakaoSocialUserDataUseCase = kakaoSocialUserDataUseCase
        self.googleSocialUserDataUseCase = googleSocialUserDataUseCase
        self.naverSocialUserDataUseCase = naverSocialUserDataUseCase
        self.serviceTokenUseCase = serviceTokenUseCase
        self.isLoggedIn = isLoggedIn
    }
}

extension LogInViewModel: ViewModelType {
    typealias InputState = TitledTextfield.InputState
    
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let logInButtonTapped: Observable<Void>
        let kakaoLogInButtonTapped: Observable<Void>
        let googleLogInButtonTapped: Observable<Void>
        let naverLogInButtonTapped: Observable<Void>
    }
    
    struct Output {
        let errorRelay: PublishRelay<Error>
        let inputStates: Driver<(InputState, InputState)>
        let isEnableLogInButton: Driver<Bool>
        let logInSucceeded: Observable<Void>
        let jwtSaved: Observable<Void>
        let googleLogIn: Observable<SocialUserData>
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
            .share()
            .asDriver(onErrorJustReturn: (true, true))
        
        let inputStates = userInputsValidation
            .map { validation in
                var states: (InputState, InputState)
                validation.0 ? (states.0 = .correct) : (states.0 = .incorrect)
                validation.1 ? (states.1 = .correct) : (states.1 = .incorrect)
                
                return states
            }
        
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
        
        let googleLogIn = input.googleLogInButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.googleSocialUserDataUseCase.logIn()
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.googleSocialUserDataUseCase.socialUserData()
            }
        
        let naverLogIn = input.naverLogInButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.naverSocialUserDataUseCase.logIn()
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
            .withUnretained(self)
            .flatMapLatest { owner, _ in
                owner.naverSocialUserDataUseCase.socialUserData()
            }
        
        let jwtSaved = Observable.merge(kakaoLogIn, googleLogIn, naverLogIn)
            .withUnretained(self)
            .do(onNext: { userData in
                print(userData)
            })
//            .flatMap { owner, socialUserData in
//                owner.authenticationUseCase.socialLogIn(requestModel: socialUserData)
//                    .compactMap { $0.tokenData.first }
//                    .map { (owner, $0) }
//            }
//            .do(onNext: { owner, serviceToken in
//                try owner.serviceTokenUseCase.saveToken(serviceToken: serviceToken)
//            })
//            .debug()
//            .materialize()
//            .do(onNext: { event in
//                if let error = event.error {
//                    errorRelay.accept(error)
//                }
//            })
//            .filter { $0.error == nil }
//            .dematerialize()
            .map { owner, _ in
                owner.isLoggedIn.onNext(true)
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
            inputStates: inputStates,
            isEnableLogInButton: isEnableLogInButton,
            logInSucceeded: logInSucceeded,
            jwtSaved: jwtSaved,
            googleLogIn: googleLogIn
        )
    }
}
