//
//  DeviceInfoCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/02.
//

import UIKit

final class DeviceInfoCell: UICollectionViewListCell {
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
    
    func configure(with deviceInfo: DeviceInfo) {
        var content = defaultContentConfiguration()
        content.text = deviceInfo.title
        content.textProperties.font = PQFont.basic
        content.textProperties.color = PQColor.text
        switchButton.isOn = deviceInfo.isOn
        
        contentConfiguration = content
    }
}
