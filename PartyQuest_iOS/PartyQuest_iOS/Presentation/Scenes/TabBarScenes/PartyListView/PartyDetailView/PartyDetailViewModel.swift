//
//  PartyDetailViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/03.
//

import RxSwift
import RxCocoa

final class PartyDetailViewModel {
    private let coordinator: PartyDetailCoordinatorType
    
    init(coordinator: PartyDetailCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension PartyDetailViewModel: ViewModelType {
    struct Input {

    }
    
    struct Output {

    }
    
    func transform(_ input: Input) -> Output {
        return Output(
        )
    }
}
