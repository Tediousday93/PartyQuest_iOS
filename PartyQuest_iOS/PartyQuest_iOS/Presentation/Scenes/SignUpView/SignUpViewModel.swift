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
    
    init(coordinator: SignUpCoordinator) {
        self.coordinator = coordinator
    }
}

extension SignUpViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let birthDate: Observable<String>
        let nickName: Observable<String>
    }
    
    struct Output {
        let isEmailValid: Driver<Bool>
        let isPasswordValid: Driver<Bool>
        let isNickNameValid: Driver<Bool>
        let isEnableSignUpButton: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let email = input.email
            .map { text in
                return text.isValidEmail()
            }
            .asDriver(onErrorJustReturn: false)
        
        let password = input.password
            .map { text in
                return text.isValidPassword()
            }
            .asDriver(onErrorJustReturn: false)
        
        let nickName = input.nickName
            .map { text in
                return text.isValidNickname()
            }
            .asDriver(onErrorJustReturn: false)
        
        let isEnableSignUpButton = Driver.combineLatest(email, password, nickName)
            .map { isEmailValidate, isPasswordValidate, isNickName in
                return isEmailValidate && isPasswordValidate && isNickName
            }
        
        return Output(isEmailValid: email,
                      isPasswordValid: password,
                      isNickNameValid: nickName,
                      isEnableSignUpButton: isEnableSignUpButton)
    }
}
