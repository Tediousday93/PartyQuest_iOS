//
//  LogInViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/14.
//

import RxSwift
import RxCocoa

final class LogInViewModel {
    private let coordinator: LogInCoordinatorType
    private let authenticationUseCase: AuthenticationUseCase
    private let userDataUseCase: UserDataUseCase
    private let serviceTokenUseCase: ServiceTokenUseCase
    
    private let isLoggedIn: PublishSubject<Bool>
    
    init(coordinator: LogInCoordinatorType,
         authenticationUseCase: AuthenticationUseCase,
         userDataUseCase: UserDataUseCase,
         serviceTokenUseCase: ServiceTokenUseCase,
         isLoggedIn: PublishSubject<Bool>) {
        self.coordinator = coordinator
        self.authenticationUseCase = authenticationUseCase
        self.userDataUseCase = userDataUseCase
        self.serviceTokenUseCase = serviceTokenUseCase
        self.isLoggedIn = isLoggedIn
    }
}

extension LogInViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let logInButtonTapped: Observable<Void>
        let kakaoLogInButtonTapped: Observable<Void>
        let googleLogInButtonTapped: Observable<Void>
        let naverLogInButtonTapped: Observable<Void>
        let willDeallocated: Observable<Void>
    }
    
    struct Output {
        let errorRelay: PublishRelay<Error>
        let inputValidation: Driver<(Bool, Bool)>
        let isEnableLogInButton: Driver<Bool>
        let jwtSaved: Observable<Void>
        let coordinatorFinished: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let errorRelay: PublishRelay<Error> = .init()
        
        let userInputs = Observable
            .combineLatest(input.email, input.password)
            .share()
        
        let inputValidation = userInputs
            .map { email, password in
                var validation = (true, true)
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
            .asDriver(onErrorJustReturn: (true, true))
        
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
            .map { LogInPlatform.kakao }
                    
        let googleLogIn = input.googleLogInButtonTapped
            .map { LogInPlatform.google }
        
        let naverLogIn = input.naverLogInButtonTapped
            .map { LogInPlatform.naver }
        
        let userData = Observable.merge(kakaoLogIn, googleLogIn, naverLogIn)
            .withUnretained(self)
            .flatMap { owner, platform in
                owner.userDataUseCase.getUserData(for: platform)
            }
        
        let socialJWT = userData
            .withUnretained(self)
            .flatMap { owner, userData in
                owner.authenticationUseCase.socialLogIn(requestModel: userData)
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
                owner.coordinator.finish()
                owner.isLoggedIn.onNext(true)
            }
        
        let coordinatorFinished = input.willDeallocated
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.finish()
            }
        
        return Output(
            errorRelay: errorRelay,
            inputValidation: inputValidation,
            isEnableLogInButton: isEnableLogInButton,
            jwtSaved: jwtSaved,
            coordinatorFinished: coordinatorFinished
        )
    }
}
