//
//  PartySearchViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/01.
//

import Foundation
import RxSwift
import RxCocoa

final class PartySearchViewModel {
    
}

extension PartySearchViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let partyItems: Observable<[PartyItem]>
    }
    
    func transform(_ input: Input) -> Output {
        let partyItems = input.viewWillAppearEvent
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
        
        return Output(
            partyItems: partyItems
        )
    }
}
