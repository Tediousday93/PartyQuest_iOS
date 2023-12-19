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
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let partyItemViewModels: Observable<[PartyItem]>
    }
    
    func transform(_ input: Input) -> Output {
        let partyItemViewModels = input.viewWillAppearEvent
            .map { _ in
                [
                    PartyItem(topImage: UIImage(named: "party_card_image"),
                              title: "알고리즘 스터디",
                              memberCount: "5/10",
                              todoQuestCount: "2",
                              doingQuestCount: "1",
                              doneQuestCount: "1",
                              partyMaster: "Harry",
                              creationDate: "생성일 2023.10.01"),
                    PartyItem(topImage: UIImage(named: "party_card_image"),
                              title: "독서파티",
                              memberCount: "5/10",
                              todoQuestCount: "2",
                              doingQuestCount: "1",
                              doneQuestCount: "1",
                              partyMaster: "Harry",
                              creationDate: "생성일 2023.10.02"),
                ]
            }
            .debug("item created")
        
        return Output(
            partyItemViewModels: partyItemViewModels
        )
    }
}
