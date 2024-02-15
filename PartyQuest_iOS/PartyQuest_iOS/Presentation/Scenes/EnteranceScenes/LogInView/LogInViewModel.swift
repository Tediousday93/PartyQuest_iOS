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
    private let socialUserUseCase: SocialUserUseCase
    
    private let isLoggedIn: PublishSubject<Bool>
    
    init(coordinator: LogInCoordinatorType,
         authenticationManager: AuthenticationManagable,
         socialUserUseCase: SocialUserUseCase,
         isLoggedIn: PublishSubject<Bool>) {
        self.coordinator = coordinator
        self.authenticationManager = authenticationManager
        self.socialUserUseCase = socialUserUseCase
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
        let inputValidation: Driver<(email: Bool, password: Bool)>
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
                var validation = (email: true, password: true)
                if email.isEmpty == false {
                    validation.email = email.isValidEmail()
                } else {
                    validation.email = true
                }
                if password.isEmpty == false {
                    validation.password = password.isValidPassword()
                } else {
                    validation.password = true
                }
                
                return validation
            }
            .asDriver(onErrorJustReturn: (email: true, password: true))
        
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
                owner.socialUserUseCase.getSocialUser(for: platform)
                    .map { (socialUser: $0, platform: platform) }
            }
            .map { socialUser, platform in
                let password: String? = nil
                
                return (email: socialUser.email,
                        password: password,
                        platform: platform)
            }
        
        let localUserData = input.logInButtonTapped
            .withLatestFrom(userInputs)
            .map { email, password in
                return (email: email,
                        password: Optional(password),
                        platform: LogInPlatform.partyQuest)
            }
        
        let jwtSaved = Observable.merge(socialUserData, localUserData)
            .withUnretained(self)
            .flatMap { owner, userData in
                owner.authenticationManager.logIn(email: userData.email,
                                                  password: userData.password,
                                                  platform: userData.platform)
                    .asObservable()
                    .map { (owner, $0.serviceToken) }
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
            .dematerialize()
            .do(onNext: { owner, serviceToken in
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
