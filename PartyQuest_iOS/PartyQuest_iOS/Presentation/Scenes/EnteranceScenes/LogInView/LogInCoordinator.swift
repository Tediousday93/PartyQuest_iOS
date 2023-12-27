//
//  LogInCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit
import RxSwift

protocol LogInCoordinatorType: Coordinator {}

final class LogInCoordinator: LogInCoordinatorType {
    var navigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    private let isLoggedIn: PublishSubject<Bool>
    
    init(navigationController: UINavigationController?,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider,
         isLoggedIn: PublishSubject<Bool>) {
        self.navigationController = navigationController
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        self.isLoggedIn = isLoggedIn
    }
    
    func start() {
        let viewModel = LogInViewModel(
            coordinator: self,
            authenticationUseCase: authenticationUseCaseProvider.makeDefaultAuthenticationUseCase(),
            kakaoSocialUserDataUseCase: socialUserDataUseCaseProvider.makeKakaoSocialUserDataUseCase(),
            googleSocialUserDataUseCase: socialUserDataUseCaseProvider.makeGoogleSocialUserDataUseCase(),
            naverSocialUserDataUseCase: socialUserDataUseCaseProvider.makeNaverSocialUserDataUseCase(),
            serviceTokenUseCase: serviceTokenUseCaseProvider.makeDefaultServiceTokenUseCase(),
            isLoggedIn: isLoggedIn
        )
        let socialLoginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(socialLoginViewController, animated: true)
    }
}
