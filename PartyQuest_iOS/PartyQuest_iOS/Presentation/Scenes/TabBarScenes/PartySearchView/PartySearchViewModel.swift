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
    private let coordinator: PartySearchCoordinatorType
    
    init(coordinator: PartySearchCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension PartySearchViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let selectedItem: Observable<PartyItem>
    }
    
    struct Output {
        let partyItems: Observable<[PartyItem]>
        let partyInfoPushed: Driver<Void>
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
                              creationDate: "2023.10.01",
                              recruitState: "모집중",
                              introduction: "알고리즘을 풀어요~"),
                    PartyItem(topImage: UIImage(named: "party_card_image"),
                              title: "독서파티",
                              memberCount: "5/10",
                              todoQuestCount: "2",
                              doingQuestCount: "1",
                              doneQuestCount: "1",
                              partyMaster: "Harry",
                              creationDate: "2023.10.02",
                              recruitState: "모집중",
                              introduction: "책을 열심히 읽어요~"),
                ]
            }
        
        let partyInfoPushed = input.selectedItem
            .withUnretained(self)
            .map { owner, item in
                owner.coordinator.toPartyInfo(partyItem: item)
            }
            .asDriver(onErrorJustReturn: ())
        
        return Output(
            partyItems: partyItems,
            partyInfoPushed: partyInfoPushed
        )
    }
}
