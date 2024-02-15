//
//  PartyInformation.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

struct PartyInformation: Codable {
    let id: UInt64?
    let coverImageName: String
    let title: String
    let description: String
    let members: [PartyMember]
    let maximumMemberCount: Int
    let questCount: QuestCount
    let partyMasterNickname: String
    let createdDate: String
    let isRecruiting: Bool
    let isPublic: Bool
}

struct QuestCount: Codable {
    let todoCount: Int
    let doingCount: Int
    let doneCount: Int
}
