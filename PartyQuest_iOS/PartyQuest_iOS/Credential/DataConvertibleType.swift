//
//  DataConvertibleType.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/16.
//

import Foundation

protocol DataConvertibleType: Encodable {
    func toData() -> Data?
}

extension DataConvertibleType {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension ServiceToken: DataConvertibleType { }
