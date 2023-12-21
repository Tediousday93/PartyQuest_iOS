//
//  Reusable.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/21.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}
