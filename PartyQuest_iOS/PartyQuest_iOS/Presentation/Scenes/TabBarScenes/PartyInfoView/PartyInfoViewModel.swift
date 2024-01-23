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
    let partyItem: BehaviorRelay<PartyItem>
    
    private let coordinator: PartyInfoCoordinatorType
    
    init(partyItem: PartyItem, coordinator: PartyInfoCoordinatorType) {
        self.partyItem = .init(value: partyItem)
        self.coordinator = coordinator
    }
    
}

extension PartyInfoViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
