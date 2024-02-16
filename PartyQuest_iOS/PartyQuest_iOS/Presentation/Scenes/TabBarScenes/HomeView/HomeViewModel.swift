//
//  HomeViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/13.
//

import RxSwift

final class HomeViewModel {
    private let coordinator: HomeCoordinatorType
    
    init(coordinator: HomeCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let homeItems: Observable<(userProfileItem: UserProfileItem,
                                   weeklyActivityItem: WeeklyActivityItem,
                                   urgentQuestItems: [UrgentQuestItem])>
    }
    
    func transform(_ input: Input) -> Output {
        let userProfileItem = input.viewWillAppearEvent
            .map { _ in
                UserProfileItem(nickName: "Harry Hyeon",
                            email: "HarryHarry@naver.com",
                            imageName: "Memoji1")
            }
        
        let weeklyActivityItem = input.viewWillAppearEvent
            .map { _ in
                WeeklyActivityItem(questCount: 10,
                             completeCount: 6)
            }
        
        let urgentQuestItems = input.viewWillAppearEvent
            .map { _ in
                [
                    UrgentQuestItem(id: 1,
                                    title: "QuestName",
                                    description: "partyName",
                                    imageName: "house.fill",
                                    dDay: "2"),
                    UrgentQuestItem(id: 2,
                                    title: "QuestName",
                                    description: "partyName",
                                    imageName: "house.fill",
                                    dDay: "3"),
                    UrgentQuestItem(id: 3,
                                    title: "QuestName",
                                    description: "partyName",
                                    imageName: "house.fill",
                                    dDay: "4"),
                ]
            }
        
        let homeItems = Observable.combineLatest(userProfileItem, weeklyActivityItem, urgentQuestItems) {
            userProfileItem, weeklyActivityItem, urgentQuestItems in
            
            return (userProfileItem: userProfileItem,
                    weeklyActivityItem: weeklyActivityItem,
                    urgentQuestItems: urgentQuestItems)
        }
        
        return Output(homeItems: homeItems)
    }
}
