//
//  PartyInfoViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/23.
//

import Foundation
import RxSwift
import RxCocoa

final class PartyInfoViewModel {
    private let partyItem: PartyItem
    private let coordinator: PartyInfoCoordinatorType
    
    init(partyItem: PartyItem, coordinator: PartyInfoCoordinatorType) {
        self.partyItem = partyItem
        self.coordinator = coordinator
    }
}

extension PartyInfoViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let partyItem: Driver<PartyItem>
    }
    
    func transform(_ input: Input) -> Output {
        let partyItem = input.viewWillAppearEvent
            .withUnretained(self)
            .map { owner, _ in
                owner.partyItem
            }
            .asDriver(onErrorJustReturn: PartyItem(topImage: nil,
                                                   title: nil,
                                                   memberCount: nil,
                                                   todoQuestCount: nil,
                                                   doingQuestCount: nil,
                                                   doneQuestCount: nil,
                                                   partyMaster: nil,
                                                   creationDate: nil,
                                                   recruitState: nil,
                                                   introduction: nil))
        
        return Output(partyItem: partyItem)
    }
}
