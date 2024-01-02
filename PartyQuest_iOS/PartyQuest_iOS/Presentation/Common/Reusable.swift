//
//  Reusable.swift
//  PartyQuest_iOS
//
//  Created by Rowan, Harry on 2023/12/12.
//

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

extension DropDownCell: Reusable {}
