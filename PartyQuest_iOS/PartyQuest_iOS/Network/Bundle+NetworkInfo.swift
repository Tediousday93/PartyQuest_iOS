//
//  Bundle+NetworkInfo.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/02.
//

import Foundation

extension Bundle {
    var baseURL: String {
        guard let filePath = Bundle.main.path(forResource: "NetworkInfo", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'NetworkInfo.plist'.")
        }
        
        guard let value = plistDict.object(forKey: "BaseURL") as? String else {
            fatalError("Couldn't find key 'BaseURL' in 'NetworkInfo.plist'.")
        }
        
        return value
    }
}
