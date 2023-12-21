//
//  Quest.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/20.
//

struct Quest: Hashable {
    let title: String
    let partyName: String
    let status: QuestStatus
    let dDay: String
    let partyImageUrl: String
}

enum QuestStatus {
    case todo
    case doing
    case done
}
