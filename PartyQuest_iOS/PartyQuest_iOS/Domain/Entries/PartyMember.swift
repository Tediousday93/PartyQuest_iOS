//
//  PartyMember.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

struct PartyMember: Codable {
    let id: UInt64
    let email: String
    let nickname: String
    let profileImageName: String
    let role: PartyRole
}

enum PartyRole: String, Codable {
    case master = "master"
    case admin = "admin"
    case member = "member"
}
