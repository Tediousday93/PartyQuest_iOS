//
//  WeekActivity.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/19.
//

import Foundation

struct WeekActivity: Hashable {
    let questCount: Int
    let completeCount: Int
    let postCount: Int
    let commentCount: Int
    
    var completeRate: Float {
        Float(completeCount) / Float(questCount)
    }
}
