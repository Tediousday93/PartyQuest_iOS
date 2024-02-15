//
//  DatePickerCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/13.
//

import UIKit

final class DatePickerCell: UICollectionViewListCell {
    var item: DatePickerItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = DatePickerContentConfiguration().updated(for: state)
        newConfiguration.item = item
        contentConfiguration = newConfiguration
    }
}
