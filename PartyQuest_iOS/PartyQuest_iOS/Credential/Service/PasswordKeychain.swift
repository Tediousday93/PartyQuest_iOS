//
//  PasswordKeychain.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/22.
//

import Security
import Foundation

final class PasswordKeychain: KeychainService {
    private let serviceName: String

    init(serviceName: String) {
        self.serviceName = serviceName
    }
    
    func saveValue(_ value: Data, forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key,
            kSecValueData: value
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            let updateQuery: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName,
                kSecAttrAccount: key
            ]

            let attributesToUpdate: [CFString: Any] = [
                kSecValueData: value
            ]

            SecItemUpdate(updateQuery as CFDictionary, attributesToUpdate as CFDictionary)
        } else if status != errSecSuccess {
            print("Error saving to keychain: \(status)")
        }
    }

    func loadValue(forKey key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            print("Error loading from keychain: \(status)")
            
            return nil
        }

        return data
    }

    func deleteValue(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting from keychain: \(status)")
        }
    }
}
