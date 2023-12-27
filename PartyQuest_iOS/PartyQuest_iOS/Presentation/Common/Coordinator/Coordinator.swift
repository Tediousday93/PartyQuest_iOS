//
//  Coordinator.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/27.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
    func start(child: Coordinator)
    func finish(child: Coordinator)
}

extension Coordinator {
    func finish() {
        parentCoordinator?.finish(child: self)
    }
    
    func start(child: Coordinator) {
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func finish(child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}
