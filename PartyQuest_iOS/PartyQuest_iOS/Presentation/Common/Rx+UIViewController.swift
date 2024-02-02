//
//  Rx+UIViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/02.
//

import UIKit
import RxSwift

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    }
    
    var viewWillAppear: Observable<Void> {
        return self.sentMessage(#selector(Base.viewWillAppear)).map { _ in }
    }
    
    var viewWillDisappear: Observable<Void> {
        return self.sentMessage(#selector(Base.viewWillDisappear)).map { _ in }
    }
}
