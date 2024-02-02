//
//  DateOptionCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/02/02.
//

import UIKit

final class DateOptionCell: UICollectionViewListCell {
    let switchButton = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let accessoryConfiuration = UICellAccessory.CustomViewConfiguration(
            customView: switchButton,
            placement: .trailing()
        )
        
        let switchAceessory = UICellAccessory.customView(configuration: accessoryConfiuration)
        accessories = [switchAceessory]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureToDateCell(with dateItem: AddQuestViewController.DateItem) {
        var content = defaultContentConfiguration()
        content.image = UIImage(systemName: "house")
        content.text = dateItem.title
        content.textProperties.font = PQFont.basic
        content.textProperties.color = PQColor.text
        content.secondaryText = dateItem.date
        content.secondaryTextProperties.color = .systemBlue
        switchButton.isOn = dateItem.isOn
        
        contentConfiguration = content
    }
    
    func configureToTimeCell(with dateItem: AddQuestViewController.DateItem) {
        var content = defaultContentConfiguration()
        content.image = UIImage(systemName: "house.fill")
        content.text = dateItem.title
        content.textProperties.font = PQFont.basic
        content.textProperties.color = PQColor.text
        content.secondaryText = dateItem.date
        content.secondaryTextProperties.color = .systemBlue
        switchButton.isOn = dateItem.isOn
        
        contentConfiguration = content
    }
}
