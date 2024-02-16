//
//  WeeklyActiviyItem.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/16.
//

struct WeeklyActivityItem: Hashable {
    let questCount: Int
    let completeCount: Int
    
    var completeRate: Float {
        Float(completeCount) / Float(questCount)
    }
}
