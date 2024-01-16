//
//  Data+JSONDecoder.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/16.
//

import Foundation

extension Data {
    func decodeJSON<T: Decodable>(to type: T.Type) -> T? {
        return try? JSONDecoder().decode(type, from: self)
    }
}
