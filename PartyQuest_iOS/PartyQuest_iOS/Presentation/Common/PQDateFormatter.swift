//
//  PQDateFormatter.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/16.
//

import Foundation

final class PQDateFormatter {
    static let shared = PQDateFormatter()
    
    private init() {}
    
    private let defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        return dateFormatter
    }()
    
    private let dotFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter
    }()
    
    private let hypenFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        
        return dateFormatter
    }()
    
    /// ex) 2024년 2월 18일
    func dateToDefaultString(from date: Date?) -> String? {
        guard let date = date else { return nil }
        
        return defaultFormatter.string(from: date)
    }
    
    /// ex) 2024.2.18
    func dateToDotString(from date: Date) -> String {
        return defaultFormatter.string(from: date)
    }
    
    /// ex) 오후 5:29
    func dateToTimeString(from date: Date?) -> String? {
        guard let date = date else { return nil }
        
        return timeFormatter.string(from: date)
    }
    
    /// ex) 2024-2-18 14:23
    func dateTimeToHypenString(from date: Date) -> String {
        return hypenFormatter.string(from: date)
    }
}
