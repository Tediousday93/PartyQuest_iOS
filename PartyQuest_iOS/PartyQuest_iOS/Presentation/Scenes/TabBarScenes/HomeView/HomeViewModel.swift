//
//  HomeViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/13.
//

import RxSwift

final class HomeViewModel {
    private let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let homeItems: Observable<(userProfile: UserProfile, weekActivity: WeekActivity)>
    }
    
    func transform(_ input: Input) -> Output {
        let userProfile = input.viewWillAppearEvent
            .map { _ in
                UserProfile(imageData: nil,
                            nickName: "Harry Hyeon",
                            email: "HarryHarry@naver.com")
            }
        
        let weekActivity = input.viewWillAppearEvent
            .map { _ in
                WeekActivity(questCount: 10,
                             completeCount: 6,
                             postCount: 4,
                             commentCount: 7)
            }
        
        let homeItems = Observable.combineLatest(userProfile, weekActivity) { userProfile, weekActivity in
            return (userProfile: userProfile, weekActivity: weekActivity)
        }
        
        return Output(homeItems: homeItems)
    }
}
