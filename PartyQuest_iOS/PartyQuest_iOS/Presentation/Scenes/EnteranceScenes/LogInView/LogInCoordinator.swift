//
//  LogInCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit
import RxSwift

final class LogInCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    private let isLoggedIn: PublishSubject<Bool>
    
    init(navigationController: UINavigationController?,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider,
         isLoggedIn: PublishSubject<Bool>) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        self.isLoggedIn = isLoggedIn
        
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = LogInViewModel(
            coordinator: self,
            authenticationUseCase: authenticationUseCaseProvider.makeDefaultAuthenticationUseCase(),
            kakaoSocialUserDataUseCase: socialUserDataUseCaseProvider.makeKakaoSocialUserDataUseCase(),
            naverSocialUserDataUseCase: socialUserDataUseCaseProvider.makeNaverSocialUserDataUseCase(),
            serviceTokenUseCase: serviceTokenUseCaseProvider.makeDefaultServiceTokenUseCase(),
            isLoggedIn: isLoggedIn
        )
        let socialLoginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(socialLoginViewController, animated: true)
    }
}
