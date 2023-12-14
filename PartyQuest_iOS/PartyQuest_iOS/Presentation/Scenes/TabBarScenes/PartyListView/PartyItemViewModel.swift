//
//  PartyItemViewModel.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/13.
//

import UIKit.UIImage
import Foundation

struct PartyItemViewModel: Hashable {
    let topImage: UIImage
    let title: String?
    let memberCount: String?
    let todoQuestCount: String?
    let doingQuestCount: String?
    let doneQuestCount: String?
    let partyMaster: String?
    let creationDate: String?
}
