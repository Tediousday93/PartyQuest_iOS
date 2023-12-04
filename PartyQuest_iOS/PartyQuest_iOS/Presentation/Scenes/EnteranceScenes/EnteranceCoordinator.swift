//
//  AppCoordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit
import RxSwift

final class EnteranceCoordinator: BaseCoordinator {
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    private let isLoggedIn: PublishSubject<Bool> = .init()
    private var disposeBag: DisposeBag = .init()
    
    init(navigationController: UINavigationController,
         authenticationUseCaseProvider: AuthenticationUseCaseProvider,
         socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider,
         serviceTokenUseCaseProvider:ServiceTokenUseCaseProvider) {
        self.authenticationUseCaseProvider = authenticationUseCaseProvider
        self.socialUserDataUseCaseProvider = socialUserDataUseCaseProvider
        self.serviceTokenUseCaseProvider = serviceTokenUseCaseProvider
        
        super.init(navigationController: navigationController)
        setBindings()
    }
    
    deinit {
        print("enterance coordinator deinited")
    }
    
    override func start() {
        self.isLoggedIn.onNext(TokenUtils.shared.isTokenExpired() == false)
    }
    
    override func didFinish(coordinator: Coordinator) {
        super.didFinish(coordinator: coordinator)
        navigationController.popViewController(animated: true)
    }
}

extension EnteranceCoordinator {
    private func setBindings() {
        isLoggedIn
            .subscribe(with: self, onNext: { owner, emitter in
                switch emitter {
                case true:
                    owner.childCoordinators.forEach { owner.didFinish(coordinator: $0) }
                    owner.coordinateToHome()
                case false:
                    owner.coordinateToWelcome()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func coordinateToWelcome() {
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            socialUserDataUseCaseProvider: socialUserDataUseCaseProvider,
            serviceTokenUseCaseProvider: serviceTokenUseCaseProvider,
            isLoggedIn: isLoggedIn
        )
        
        start(coordinator: coordinator)
    }
    
    private func coordinateToHome() {
        
    }
}
