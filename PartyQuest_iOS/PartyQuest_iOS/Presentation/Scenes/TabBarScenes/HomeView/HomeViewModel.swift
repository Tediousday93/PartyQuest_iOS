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
        let homeItems: Observable<(userProfile: UserProfile,
                                   weekActivity: WeekActivity,
                                   doingQuests: [Quest])>
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
        
        let doingQuests = input.viewWillAppearEvent
            .map { _ in
                [
                    Quest(title: "백준 385번 풀기",
                          partyName: "알고리즘 스터디",
                          status: .doing,
                          dDay: "2",
                          partyImageUrl: "house.fill"),
                    
                    Quest(title: "1,2,3번 연습하기",
                          partyName: "iOS 면접 스터디",
                          status: .doing,
                          dDay: "3",
                          partyImageUrl: "house"),
                    
                    Quest(title: "개인책 20쪽 읽기",
                          partyName: "독서파티",
                          status: .doing,
                          dDay: "3",
                          partyImageUrl: "house")
                ]
            }
        
        let homeItems = Observable.combineLatest(userProfile, weekActivity, doingQuests) {
            userProfile, weekActivity, doingQuests in
            
            return (userProfile: userProfile, weekActivity: weekActivity, doingQuests: doingQuests)
        }
        
        return Output(homeItems: homeItems)
    }
}
