//
//  KeychainService.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/16.
//

import Foundation

protocol KeychainService {
    func saveValue(_ value: Data, forKey key: String)
    func loadValue(forKey key: String) -> Data?
    func deleteValue(forKey key: String)
}
