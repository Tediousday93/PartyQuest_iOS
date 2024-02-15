//
//  TimePickerCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/14.
//

import UIKit

final class TimePickerCell: UICollectionViewListCell {
    var item: TimePickerItem?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = TimePickerContentConfiguration().updated(for: state)
        newConfiguration.item = item
        contentConfiguration = newConfiguration
    }
}
