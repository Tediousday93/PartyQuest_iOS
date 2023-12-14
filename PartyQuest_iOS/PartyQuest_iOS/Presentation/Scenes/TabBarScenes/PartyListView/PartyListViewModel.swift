//
//  PartyListViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/29.
//

import RxSwift
import RxCocoa

final class PartyListViewModel {
    
}

extension PartyListViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let partyItemViewModels: Observable<[PartyItemViewModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let partyItemViewModels = input.viewDidLoadEvent
            .map { _ in
                [
                    PartyItemViewModel(topImage: nil,
                                       title: "알고리즘 스터디",
                                       memberCount: "5/10",
                                       todoQuestCount: "2",
                                       doingQuestCount: "1",
                                       doneQuestCount: "1",
                                       partyMaster: "Harry",
                                       creationDate: "생성일 2023.10.01"),
                    PartyItemViewModel(topImage: nil,
                                       title: "독서파티",
                                       memberCount: "5/10",
                                       todoQuestCount: "2",
                                       doingQuestCount: "1",
                                       doneQuestCount: "1",
                                       partyMaster: "Harry",
                                       creationDate: "생성일 2023.10.02"),
                ]
            }
        
        return Output(
            partyItemViewModels: partyItemViewModels
        )
    }
}
