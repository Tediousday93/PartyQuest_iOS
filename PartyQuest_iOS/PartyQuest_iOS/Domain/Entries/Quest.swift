//
//  Quest.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/20.
//

import Foundation

/*
 Hashable -> 채택하지 않음. DTO로서 역할만 하고
 Hashable 채택하는 타입은 뷰 모델에 따로 만들어두고
 서버 response에서 decoding 성공 후 변환하여 뷰에 뿌려주기
*/
struct Quest: Codable {
    let id: UInt64?
    let title: String
    let description: String
    let startTime: String
    let endTime: String
    let submittedMembers: [PartyMember]
}

// 뷰모델로 이동 필요
//enum QuestStatus {
//    case todo
//    case doing
//    case done
//
//    var badgeImageName: String {
//        switch self {
//        case .todo:
//            return "todoBadge"
//        case .doing:
//            return "doingBadge"
//        case .done:
//            return "doneBadge"
//        }
//    }
//}
