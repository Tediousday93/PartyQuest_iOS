//
//  LogInCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import Foundation
import UIKit

final class LogInCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    init(navigationController: UINavigationController,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = LogInViewModel(
            coordinator: self,
            authenticationUseCase: authenticationUseCaseProvider.makeDefaultAuthenticationUseCase(),
            kakaoSocialUserDataUseCase: socialUserDataUseCaseProvider.makeKakaoSocialUserDataUseCase(),
            serviceTokenUseCase: serviceTokenUseCaseProvider.makeDefaultServiceTokenUseCase()
        )
        let socialLoginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController.pushViewController(socialLoginViewController, animated: true)
    }
}
