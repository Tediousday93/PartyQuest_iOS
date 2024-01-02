//
//  PQApplication.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var tabBarController: PQTabBarController?
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow?
    
    private let authenticationUseCaseProvider: AuthenticationUseCaseProvider
    private let socialUserDataUseCaseProvider: SocialUserDataUseCaseProvider
    private let serviceTokenUseCaseProvider: ServiceTokenUseCaseProvider
    
    private let isLoggedIn: PublishSubject<Bool> = .init()
    private var disposeBag: DisposeBag = .init()
    
    init(window: UIWindow?) {
        self.window = window
        self.authenticationUseCaseProvider = DefaultAuthenticationUseCaseProvider()
        self.socialUserDataUseCaseProvider = DefaultSocialUserDataUseCaseProvider()
        self.serviceTokenUseCaseProvider = DefaultServiceTokenUseCaseProvider()
        self.tabBarController = nil
        
        setBindings()
    }
    
    deinit {
        disposeBag = .init()
    }
    
    func start() {
//        self.isLoggedIn.onNext(TokenUtils.shared.isTokenExpired() == false)
        toHome()
    }
}

extension AppCoordinator {
    private func setBindings() {
        isLoggedIn
            .subscribe(with: self, onNext: { owner, emitter in
                switch emitter {
                case true:
                    owner.childCoordinators.removeAll()
                    owner.navigationController?.viewControllers.removeAll()
                    owner.navigationController = nil
                    owner.toHome()
                case false:
                    owner.childCoordinators.removeAll()
                    owner.tabBarController?.dismiss(animated: true)
                    owner.toWelcome()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func toWelcome() {
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let coordinator = WelcomeCoordinator(
            navigationController: navigationController,
            authenticationUseCaseProvider: authenticationUseCaseProvider,
            socialUserDataUseCaseProvider: socialUserDataUseCaseProvider,
            serviceTokenUseCaseProvider: serviceTokenUseCaseProvider,
            isLoggedIn: isLoggedIn
        )
        
        start(child: coordinator)
    }
    
    private func toHome() {
        self.tabBarController = PQTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "home"),
            selectedImage: UIImage(systemName: "home.fill")
        )
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        let partyListNavigationController = UINavigationController()
        let partyListCoordinator = PartyListCoordinator(navigationController: partyListNavigationController)
        let tabBarImage = UIImage(systemName: "person.2")
        let tabBarSelectedImage = UIImage(systemName: "person.2.fill")
        partyListNavigationController.tabBarItem = .init(title: nil, image: tabBarImage, selectedImage: tabBarSelectedImage)
        
        tabBarController?.viewControllers = [homeNavigationController, partyListNavigationController]
        
        start(child: homeCoordinator)
        start(child: partyListCoordinator)
    }
}
