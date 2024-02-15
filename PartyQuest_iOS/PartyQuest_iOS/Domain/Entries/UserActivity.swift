//
//  UserActivity.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

struct UserActivity: Decodable {
    let weeklyTotalQuestCount: Int
    let weeklyTotalCompleteCount: Int
    let urgentQuests: [UrgentQuest]
}

struct UrgentQuest: Decodable {
    let id: UInt64
    let partyID: UInt64
    let partyImageName: String
    let title: String
    let endTime: String
}