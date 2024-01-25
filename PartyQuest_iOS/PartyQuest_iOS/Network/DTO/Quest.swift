//
//  Quest.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/20.
//

import Foundation

struct Quest: Hashable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let partyName: String
    let status: QuestStatus
    let dDay: String
    let partyImageUrl: String
}

enum QuestStatus {
    case todo
    case doing
    case done
    
    var badgeImageName: String {
        switch self {
        case .todo:
            return "todoBadge"
        case .doing:
            return "doingBadge"
        case .done:
            return "doneBadge"
        }
    }
}
