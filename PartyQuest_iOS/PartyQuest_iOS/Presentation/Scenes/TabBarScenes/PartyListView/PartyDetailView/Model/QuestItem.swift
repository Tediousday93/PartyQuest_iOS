//
//  QuestItem.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/16.
//

struct QuestItem: Hashable {
    let id: UInt64
    let status: QuestStatus
    let title: String
    let description: String
    let startTime: String
    let endTime: String
    let dDay: String
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
