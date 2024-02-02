//
//  ModifyingListCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/02.
//

import UIKit

final class ModifyingListCell: UICollectionViewListCell {
    typealias Item = ModifyingListViewController.ModifyingItem
    
    let modifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.tintColor = .white
        button.backgroundColor = PQColor.buttonMain
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let accessoryConfiguration = UICellAccessory.CustomViewConfiguration(
            customView: modifyButton,
            placement: .trailing()
        )
        
        let trailingModifyButton = UICellAccessory.customView(configuration: accessoryConfiguration)
        
        self.accessories = [trailingModifyButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ModifyingListCell {
    func configure(with item: Item) {
        var contentConfiguration = defaultContentConfiguration()
        contentConfiguration.textProperties.font = PQFont.small
        contentConfiguration.textProperties.color = PQColor.lightGray
        contentConfiguration.secondaryTextProperties.font = PQFont.basic
        contentConfiguration.secondaryTextProperties.color = .black
        contentConfiguration.text = item.title
        contentConfiguration.secondaryText = item.body
        
        self.contentConfiguration = contentConfiguration
    }
}
