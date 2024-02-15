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

    private let authenticationManagerProvider: AuthenticationManagerProvider
    private let socialUserUseCaseProvider: SocialUserUseCaseProvider
    private let isLoggedIn: PublishSubject<Bool>
    
    init(navigationController: UINavigationController?,
         authenticationManagerProvider: AuthenticationManagerProvider,
         socialUserUseCaseProvider: SocialUserUseCaseProvider,
         isLoggedIn: PublishSubject<Bool>) {
        self.navigationController = navigationController
        self.authenticationManagerProvider = authenticationManagerProvider
        self.socialUserUseCaseProvider = socialUserUseCaseProvider
        self.isLoggedIn = isLoggedIn
    }
    
    func start() {
        let viewModel = LogInViewModel(
            coordinator: self,
            authenticationManager: authenticationManagerProvider.makePQAuthManager(),
            socialUserUseCase: socialUserUseCaseProvider.makeSocialUserUseCase(),
            isLoggedIn: isLoggedIn
        )
        let socialLoginViewController = LogInViewController(viewModel: viewModel)
        
        navigationController?.pushViewController(socialLoginViewController, animated: true)
    }
}
