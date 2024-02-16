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
        let todoQeusts: Observable<[QuestItem]>
        let doingQeusts: Observable<[QuestItem]>
        let doneQeusts: Observable<[QuestItem]>
        let presentAddQuestView: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let quests = input.viewWillAppearEvent
            .map { _ in
                [
                    QuestItem(id: 1,
                              status: .todo,
                              title: "백준 385번 풀기",
                              description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                              startTime: "2024년 1월 12일",
                              endTime: "2024년 1월 14일",
                              dDay: "2"),
                    QuestItem(id: 2,
                              status: .todo,
                              title: "백준 385번 풀기",
                              description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                              startTime: "2024년 1월 12일",
                              endTime: "2024년 1월 14일",
                              dDay: "2"),
                    QuestItem(id: 3,
                              status: .doing,
                              title: "백준 385번 풀기",
                              description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                              startTime: "2024년 1월 12일",
                              endTime: "2024년 1월 14일",
                              dDay: "2"),
                    QuestItem(id: 4,
                              status: .done,
                              title: "백준 385번 풀기",
                              description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                              startTime: "2024년 1월 12일",
                              endTime: "2024년 1월 14일",
                              dDay: "2"),
                    QuestItem(id: 5,
                              status: .done,
                              title: "백준 385번 풀기",
                              description: "각자 푼 뒤에 스크린샷을 제출해주세요",
                              startTime: "2024년 1월 12일",
                              endTime: "2024년 1월 14일",
                              dDay: "2"),
                ]
            }
        
        let todoQuests = quests
            .map { quests in
                quests.filter { $0.status == .todo }
            }
        
        let doingQuests = quests
            .map { quests in
                quests.filter { $0.status == .doing }
            }
        
        let doneQuests = quests
            .map { quests in
                quests.filter { $0.status == .done }
            }
        
        let presentAddQuestView = input.addQuestButtonTapped
            .withUnretained(self)
            .map { owner, _ in
                owner.coordinator.toAddQuest()
            }
        
        return Output(
            todoQeusts: todoQuests,
            doingQeusts: doingQuests,
            doneQeusts: doneQuests,
            presentAddQuestView: presentAddQuestView
        )
    }
}
