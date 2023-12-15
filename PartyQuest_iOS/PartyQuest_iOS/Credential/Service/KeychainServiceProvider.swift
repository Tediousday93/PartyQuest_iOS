//
//  KeychainServiceProvider.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/23.
//

import Foundation

final class KeychainServiceProvider {
    func makePasswordKeychain() -> KeychainService {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            fatalError("Cannot find bundleIdentifier")
        }
        
        return PasswordKeychain(service: bundleID)
    }
}
