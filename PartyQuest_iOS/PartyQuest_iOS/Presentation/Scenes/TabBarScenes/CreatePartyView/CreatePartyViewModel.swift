//
//  CreatePartyViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import RxSwift
import RxCocoa

final class CreatePartyViewModel {
    private let coordinator: CreatePartyCoordinatorType
    
    private let partyInfoItems: BehaviorRelay<[ModifyingItem]> = .init(value: [
        .init(title: "파티 이미지", value: "핑크 오렌지"),
        .init(title: "파티명", value: ""),
        .init(title: "파티 소개", value: ""),
        .init(title: "최대인원", value: "5"),
        .init(title: "파티 상태", value: "모집중, 공개")
    ])
    
    init(coordinator: CreatePartyCoordinatorType) {
        self.coordinator = coordinator
    }
}

extension CreatePartyViewModel: ViewModelType {
    struct Input {
        let cancelBarButtonTapped: Observable<Void>
        let modifyButtonTapped: Observable<(event: Void, itemIndex: Int)>
        let willDeallocated: Observable<Void>
    }
    
    struct Output {
        let partyInfoItems: BehaviorRelay<[ModifyingItem]>
        let dismiss: Driver<Void>
        let modifyingViewPresented: Driver<Void>
        let isEnableCompleteBarButton: Driver<Bool>
        let coordinatorFinished: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let dismiss = input.cancelBarButtonTapped
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.coordinator.toPartyList()
            }
            .asDriver(onErrorJustReturn: ())
        
        let modifyingViewPresented = input.modifyButtonTapped
            .withUnretained(self)
            .map { owner, emittedValue in
                owner.coordinator.presentModifyingView(with: owner.partyInfoItems, itemIndex: emittedValue.itemIndex)
            }
            .asDriver(onErrorJustReturn: ())
        
        let isEnableCompleteBarButton = partyInfoItems.skip(1)
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)
        
        let coordinatorFinished = input.willDeallocated
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.finish()
            }
        
        return Output(
            partyInfoItems: partyInfoItems,
            dismiss: dismiss,
            modifyingViewPresented: modifyingViewPresented,
            isEnableCompleteBarButton: isEnableCompleteBarButton,
            coordinatorFinished: coordinatorFinished
        )
    }
}
