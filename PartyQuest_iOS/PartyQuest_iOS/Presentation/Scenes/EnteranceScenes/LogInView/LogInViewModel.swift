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
        let jwtSaved: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorRelay: PublishRelay<Error> = .init()
        
        let userInputs = Observable
            .combineLatest(input.email, input.password)
            .share()
        
        let inputStates = userInputs
            .map { email, password in
                var validation = (false, false)
                if email.isEmpty == false {
                    validation.0 = email.isValidEmail()
                } else {
                    validation.0 = true
                }
                if password.isEmpty == false {
                    validation.1 = password.isValidPassword()
                } else {
                    validation.1 = true
                }
                
                return validation
            }
            .asDriver(onErrorJustReturn: (false, false))
            .map { validation in
                var states: (InputState, InputState)
                validation.0 ? (states.0 = .correct) : (states.0 = .incorrect)
                validation.1 ? (states.1 = .correct) : (states.1 = .incorrect)
                
                return states
            }
        
        let isEnableLogInButton = userInputs
            .map { email, password in
                var validation = (false, false)
                if email.isEmpty == false {
                    validation.0 = email.isValidEmail()
                }
                if password.isEmpty == false {
                    validation.1 = password.isValidPassword()
                }
                return validation
            }
            .map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
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
        
        let socialJWT = Observable.merge(kakaoLogIn, googleLogIn, naverLogIn)
            .withUnretained(self)
            .do(onNext: { userData in
                print(userData)
            })
            .flatMap { owner, socialUserData in
                owner.authenticationUseCase.socialLogIn(requestModel: socialUserData)
                    .compactMap { $0.tokenData.first }
                    .map { (owner, $0) }
            }
        
        let serverJWT = input.logInButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password in
                return (email: email, password: password)
            }
            .withUnretained(self)
            .flatMap { owner, userInputs in
                owner.authenticationUseCase.logIn(email: userInputs.email,
                                                  password: userInputs.password)
                .asObservable()
                .compactMap { $0.tokenData.first }
                .map { (owner, $0) }
            }
        
        let jwtSaved = Observable.merge(socialJWT, serverJWT)
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
        
        return Output(
            errorRelay: errorRelay,
            inputStates: inputStates,
            isEnableLogInButton: isEnableLogInButton,
            jwtSaved: jwtSaved
        )
    }
}
