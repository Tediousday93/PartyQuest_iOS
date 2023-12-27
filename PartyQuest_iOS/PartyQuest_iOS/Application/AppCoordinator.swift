//
//  PQApplication.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import UIKit
import RxSwift

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow?
    private var tabBarController: PQTabBarController?
    
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
        
        super.init(navigationController: nil)
        setBindings()
    }
    
    deinit {
        disposeBag = .init()
        print("enterance coordinator deinited")
    }
    
    override func start() {
//        self.isLoggedIn.onNext(TokenUtils.shared.isTokenExpired() == false)
        coordinateToHome()
    }
    
    override func didFinish(coordinator: Coordinator) {
        super.didFinish(coordinator: coordinator)
        navigationController?.popViewController(animated: true)
    }
}

extension AppCoordinator {
    private func setBindings() {
        isLoggedIn
            .subscribe(with: self, onNext: { owner, emitter in
                switch emitter {
                case true:
                    owner.navigationController?.viewControllers.removeAll()
                    owner.navigationController = nil
                    owner.coordinateToHome()
                case false:
                    owner.tabBarController?.dismiss(animated: true)
                    owner.coordinateToWelcome()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func coordinateToWelcome() {
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
        
        start(coordinator: coordinator)
    }
    
    private func coordinateToHome() {
//        let partyListTabBarItem = UITabBarItem(title: nil,
//                                          image: UIImage(systemName: "person.2"),
//                                          selectedImage: UIImage(systemName: "person.2.fill"))
//        let searchTabBarItem = UITabBarItem(title: nil,
//                                          image: UIImage(systemName: "magnifyingglass"),
//                                          selectedImage: nil)
//        let alertTabBarItem = UITabBarItem(title: nil,
//                                          image: UIImage(systemName: "bell"),
//                                          selectedImage: UIImage(systemName: "bell.fill"))
        
        let homeNavigationController = UINavigationController()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "home"),
            selectedImage: UIImage(systemName: "home.fill")
        )
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        start(coordinator: homeCoordinator)
        
        let settingNavigationController = UINavigationController()
        settingNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        let settingCoordinator = SettingCoordinator(navigationController: settingNavigationController)
        start(coordinator: settingCoordinator)
        
        self.tabBarController = PQTabBarController()
        tabBarController?.viewControllers = [
            homeNavigationController,
            settingNavigationController
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
