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
        let viewWillAppearEvent: Observable<Void>
        let addQuestButtonTapped: Observable<Void>
    }
    
    struct Output {
        let todoQeusts: Observable<[Quest]>
        let doingQeusts: Observable<[Quest]>
        let doneQeusts: Observable<[Quest]>
        let presentAddQuestView: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let quests = input.viewWillAppearEvent
            .map { _ in
                [
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .todo,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .doing,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .todo,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .todo,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .doing,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .doing,
                          dDay: "2",
                          partyImageUrl: "dd"),
                    Quest(title: "백준 385번 풀기",
                          description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                          partyName: "알고리즘 스터디",
                          status: .done,
                          dDay: "2",
                          partyImageUrl: "dd"),
                ]
            }
        
        let todoQuest = quests
            .map { quests in
                quests.filter { $0.status == .todo }
            }
        
        let doingQuest = quests
            .map { quests in
                quests.filter { $0.status == .doing }
            }
        
        let doneQuest = quests
            .map { quests in
                quests.filter { $0.status == .done }
            }
        
        let presentAddQuestView = input.addQuestButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                print("Button Tapped")
                owner.coordinator.toAddQuest()
            }
        
        return Output(
            todoQeusts: todoQuest,
            doingQeusts: doingQuest,
            doneQeusts: doneQuest,
            presentAddQuestView: presentAddQuestView
        )
    }
}
