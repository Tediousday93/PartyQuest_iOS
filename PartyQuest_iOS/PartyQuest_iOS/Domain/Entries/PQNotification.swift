//
//  PQNotification.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

struct QuestNotification: Decodable {
        let id: UInt64
        let type: String
        let date: String
        let partyID: UInt64
        let imageName: String
        let title: String
        let subtitle: String
        let isChecked: Bool

        enum CodingKeys: String, CodingKey {
            case id = "notificationID"
            case type = "notificationType"
            case date = "notificationDate"
            case partyID
            case imageName = "partyImageName"
            case title = "partyTitle"
            case subtitle = "questTitle"
            case isChecked
        }
}

struct InviteNotification: Decodable {
        let id: UInt64
        let invitedPartyID: UInt64
        let imageName: String
        let title: String
        let subtitle: String
        let message: String
        let date: String
        let isChecked: Bool

        enum Codingkeys: String, CodingKey {
            case id = "notificationID"
            case invitedPartyID
            case imageName = "hostImageName"
            case title = "hostName"
            case subtitle = "partyName"
            case message
            case date = "notificationDate"
            case isChecke
        }
}
