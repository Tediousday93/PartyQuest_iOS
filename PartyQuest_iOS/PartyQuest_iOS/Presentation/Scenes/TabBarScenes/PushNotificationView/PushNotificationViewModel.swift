//
//  PushNotificationViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/03.
//

import Foundation
import RxSwift
import RxCocoa

final class PushNotificationViewModel {
    private let coordinator: PushNotificationCoordinatorType
    
    init(coordinator: PushNotificationCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension PushNotificationViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let dataSource: Observable<[PushNotification]>
    }
    
    func transform(_ input: Input) -> Output {
        let dataSourceFetched = input.viewWillAppearEvent
            .map { _ in
                [
                    PushNotification(imageName: "Mimoji",
                                     title: "Rowan",
                                     subtitle: "알고리즘 스터디",
                                     message: "Rowan님이 퀘스트를 발행했습니다!",
                                     isBadgeNeeded: true,
                                     isChecked: false,
                                     date: "2일전"),
                    PushNotification(imageName: "Mimoji",
                                     title: "Harry",
                                     subtitle: "알고리즘 스터디",
                                     message: "Harry님이 퀘스트를 발행했습니다!",
                                     isBadgeNeeded: true,
                                     isChecked: true,
                                     date: "어제"),
                ]
            }
        
        return Output(
            dataSource: dataSourceFetched
        )
    }
}
