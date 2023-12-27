//
//  CreatePartyViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import RxSwift
import RxCocoa

final class CreatePartyViewModel {
    let coordinator: CreatePartyCoordinatorType
    
    init(coordinator: CreatePartyCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension CreatePartyViewModel: ViewModelType {
    struct Input {
        let cancelBarButtonTapped: Observable<Void>
        let partyName: Observable<String>
        let introduction: Observable<String>
        let memberCount: Observable<String>
    }
    
    struct Output {
        let dismiss: Driver<Void>
        let isEnableCompleteBarButton: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = input.cancelBarButtonTapped
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.coordinator.toPartyList()
            }
            .asDriver(onErrorJustReturn: ())
        
        let isEnableCompleteBarButton = Observable.combineLatest(input.partyName, input.introduction, input.memberCount)
            .map { partyName, introduction, memberCount in
                return partyName.isEmpty == false && introduction.isEmpty == false && memberCount.isEmpty == false
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            dismiss: dismiss,
            isEnableCompleteBarButton: isEnableCompleteBarButton
        )
    }
}
