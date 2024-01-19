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
    private let authenticationManager: AuthenticationManagable
    private let userDataUseCase: UserDataUseCase
    
    private let isLoggedIn: PublishSubject<Bool>
    
    init(coordinator: LogInCoordinatorType,
         authenticationManager: AuthenticationManagable,
         userDataUseCase: UserDataUseCase,
         isLoggedIn: PublishSubject<Bool>) {
        self.coordinator = coordinator
        self.authenticationManager = authenticationManager
        self.userDataUseCase = userDataUseCase
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
        
        let socialUserData = Observable.merge(kakaoLogIn, googleLogIn, naverLogIn)
            .withUnretained(self)
            .flatMap { owner, platform in
                owner.userDataUseCase.getUserData(for: platform)
            }
        
        let localUserData = input.logInButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password in
                return UserData(email: email, secrets: password)
            }
        
        let jwtSaved = Observable.merge(socialUserData, localUserData)
            .withUnretained(self)
            .flatMap { owner, userData in
                owner.authenticationManager.logIn(userData: userData)
                    .asObservable()
                    .compactMap { $0.first }
                    .map { (owner, $0) }
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
            .dematerialize()
            .do(onNext: { _, serviceToken in
                TokenUtils.shared.saveToken(serviceToken: serviceToken)
            })
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
