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
    
    init(navigationController: UINavigationController,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let viewModel = LogInViewModel(
            coordinator: self,
            authenticationUseCase: authenticationUseCaseProvider.makeDefaultAuthenticationUseCase(),
            kakaoSocialUserDataUseCase: socialUserDataUseCaseProvider.makeKakaoSocialUserDataUseCase()
        )
        let socialLoginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController.pushViewController(socialLoginViewController, animated: true)
    }
}
